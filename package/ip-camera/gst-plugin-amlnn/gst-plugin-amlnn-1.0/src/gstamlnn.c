/*
 * GStreamer
 * Copyright (C) 2006 Stefan Kost <ensonic@users.sf.net>
 * Copyright (C) 2018 Jemy Zhang <<jun.zhang@amlogic.com>>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

/**
 * SECTION:element-amlnn
 *
 * FIXME:Describe amlnn here.
 *
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * gst-launch -v -m fakesrc ! amlnn ! fakesink silent=TRUE
 * ]|
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/gst.h>
#include <gst/base/base.h>
#include <gst/video/video.h>
#include <gst/controller/controller.h>
#include <gmodule.h>

#include "gstamlnn.h"

GST_DEBUG_CATEGORY_STATIC (gst_aml_nn_debug);
#define GST_CAT_DEFAULT gst_aml_nn_debug

typedef struct Relative_DetectPoint {
  float rel_left;
  float rel_top;
  float rel_right;
  float rel_bottom;
} RDetectPoint_t;

#define DEFAULT_PROP_MODEL_TYPE DET_YOLOFACE_V2

/* Filter signals and args */
enum
{
  /* FILL ME */
  LAST_SIGNAL
};

enum
{
  PROP_0,
  PROP_MODEL_TYPE,
};

#define GST_TYPE_AML_DET_MODEL_TYPE (gst_aml_detect_model_get_type())
static GType
gst_aml_detect_model_get_type (void)
{
  static GType aml_detect_model_type = 0;
  static const GEnumValue aml_detect_model [] = {
    {DET_YOLOFACE_V2, "nn-v2", "nn v2"},
    {DET_YOLO_V2, "yolo-v2", "yolo v2"},
    {DET_YOLO_V3, "yolo-v3", "yolo v3"},
    {DET_YOLO_TINY, "yolo-tiny", "yolo tiny"},
    {DET_SSD, "ssd", "ssd"},
    {DET_MTCNN_V1, "mtcnn-v1", "mtcnn v1"},
	{DET_MTCNN_V2, "mtcnn-v2", "mtcnn v2"},
	{DET_FASTER_RCNN, "faster-rcnn", "faster rcnn"},
	{DET_DEEPLAB_V1, "deeplab-v1", "deeplab v1"},
	{DET_DEEPLAB_V2, "deeplab-v2", "deeplab v2"},
	{DET_DEEPLAB_V3, "deeplab-v3", "deeplab v3"},
    {0, NULL, NULL},
  };

  if (!aml_detect_model_type) {
    aml_detect_model_type =
        g_enum_register_static ("GstAMLDetectModel",
        aml_detect_model);
  }
  return aml_detect_model_type;
}

/* the capabilities of the inputs and outputs.
 *
 * FIXME:describe the real formats here.
 */
static GstStaticPadTemplate sink_template =
GST_STATIC_PAD_TEMPLATE (
  "sink",
  GST_PAD_SINK,
  GST_PAD_ALWAYS,
  GST_STATIC_CAPS ("video/x-raw, "
      "framerate = (fraction) [0/1, MAX], "
      "width = (int) [ 1, MAX ], " "height = (int) [ 1, MAX ], "
      "format = (string) { RGB } ")
);

#define gst_aml_nn_parent_class parent_class
G_DEFINE_TYPE (GstAmlNN, gst_aml_nn, GST_TYPE_BASE_SINK);

static void gst_aml_nn_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_aml_nn_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

static gboolean gst_aml_nn_open (GstAmlNN * base);

static gboolean gst_aml_nn_close (GstAmlNN * base);

static void gst_aml_nn_finalize (GObject * object);

static GstFlowReturn gst_aml_nn_render (GstBaseSink * base,
    GstBuffer * outbuf);

static gboolean gst_aml_nn_set_caps (GstBaseSink * base,
    GstCaps * caps);

static GstCaps * gst_aml_nn_get_caps (GstBaseSink * base,
    GstCaps * filter);

static gpointer detect_result_process (void *data);
/* GObject vmethod implementations */

/* initialize the amlnn's class */
static void
gst_aml_nn_class_init (GstAmlNNClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;

  gobject_class = (GObjectClass *) klass;
  gstelement_class = (GstElementClass *) klass;

  gobject_class->set_property = gst_aml_nn_set_property;
  gobject_class->get_property = gst_aml_nn_get_property;
  gobject_class->finalize = gst_aml_nn_finalize;

  g_object_class_install_property (G_OBJECT_CLASS (klass), PROP_MODEL_TYPE,
      g_param_spec_enum ("model-type", "model-type",
          "detection model type", GST_TYPE_AML_DET_MODEL_TYPE,
          DEFAULT_PROP_MODEL_TYPE, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gst_element_class_set_details_simple (gstelement_class,
    "amlnn",
    "Generic/Filter",
    "Amlogic NN Detection module",
    "Jemy Zhang <jun.zhang@amlogic.com>");

  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&sink_template));

  GST_BASE_SINK_CLASS (klass)->render =
      GST_DEBUG_FUNCPTR (gst_aml_nn_render);

  GST_BASE_SINK_CLASS (klass)->set_caps =
      GST_DEBUG_FUNCPTR (gst_aml_nn_set_caps);
  GST_BASE_SINK_CLASS (klass)->get_caps =
      GST_DEBUG_FUNCPTR (gst_aml_nn_get_caps);
}

/* initialize the new element
 * initialize instance structure
 */
static void
gst_aml_nn_init (GstAmlNN *filter)
{
  filter->is_info_set = FALSE;
  filter->model_type = DEFAULT_PROP_MODEL_TYPE;
  filter->src_srcpad = NULL;

  g_cond_init (&filter->_cond);
  g_mutex_init (&filter->_mutex);
  filter->_running = TRUE;
  filter->_thread = g_thread_new ("detect process", detect_result_process, filter);

  gst_aml_nn_open (filter);
}

static void
change_model (GstAmlNN *filter, det_model_type type) {
  GST_ERROR_OBJECT (filter, "set model type = %d", type);
  if (type != filter->model_type) {
    g_mutex_lock (&filter->_mutex);
    det_release_model (filter->model_type);
    det_set_model (type);
    filter->model_type = type;
    g_mutex_unlock (&filter->_mutex);
  }

}

static void
gst_aml_nn_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstAmlNN *filter = GST_AMLNN (object);

  switch (prop_id) {
    case PROP_MODEL_TYPE:
      change_model (filter, g_value_get_enum (value));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_aml_nn_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstAmlNN *filter = GST_AMLNN (object);

  switch (prop_id) {
    case PROP_MODEL_TYPE:
      g_value_set_enum (value, filter->model_type);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static gboolean
gst_aml_nn_open (GstAmlNN * filter)
{
  det_set_log_config (DET_DEBUG_LEVEL_ERROR, DET_LOG_TERMINAL);

  if (filter->model_type == DET_BUTT) return FALSE;

  if (det_set_model (filter->model_type) != DET_STATUS_OK) {
    GST_ERROR_OBJECT (filter, "failed to initialize the nn detect library");
    return FALSE;
  }

  det_get_model_size (filter->model_type,
      &filter->model_width, &filter->model_height, &filter->model_channel);
  return TRUE;
}

static gboolean
gst_aml_nn_close (GstAmlNN * filter)
{
  if (det_release_model (filter->model_type) != DET_STATUS_OK) {
    return FALSE;
  }
  filter->model_type = DET_BUTT;
  return TRUE;
}

static void
gst_aml_nn_finalize (GObject * object)
{
  GstAmlNN *filter = GST_AMLNN (object);

  gst_aml_nn_close (filter);

  filter->_running = FALSE;
  g_mutex_lock (&filter->_mutex);
  g_cond_signal (&filter->_cond);
  g_mutex_unlock (&filter->_mutex);
  g_thread_join (filter->_thread);
  filter->_thread = NULL;

  G_OBJECT_CLASS (parent_class)->finalize (object);
}


static gboolean
gst_aml_nn_set_caps (GstBaseSink * base, GstCaps * caps)
{
  GstAmlNN *filter = GST_AMLNN (base);
  GstVideoInfo info;

  if (!gst_video_info_from_caps (&info, caps))
  {
    GST_ERROR_OBJECT (base, "caps are invalid");
    return FALSE;
  }
  filter->info = info;
  filter->is_info_set = TRUE;
  return TRUE;
}

static GstCaps *
gst_aml_nn_get_caps (GstBaseSink * base, GstCaps * filter)
{
  GstAmlNN *amlnn;
  GstCaps *caps;

  amlnn = GST_AMLNN (base);
  caps = gst_static_pad_template_get_caps (&sink_template);

  caps = gst_caps_make_writable (caps);
  gst_caps_set_simple(caps,
      "width", G_TYPE_INT, amlnn->model_width,
      "height", G_TYPE_INT, amlnn->model_height,
      NULL);

  if (filter != NULL) {
    GstCaps *icaps;

    icaps = gst_caps_intersect(caps, filter);
    gst_caps_unref(caps);
    caps = icaps;
  }
  return caps;
}

/* GstBaseSink vmethod implementations */
#define GST_EVENT_NN_DETECTED GST_EVENT_MAKE_TYPE(80, GST_EVENT_TYPE_DOWNSTREAM | GST_EVENT_TYPE_SERIALIZED)

static GstPad *
find_source_pad (GstBaseSink * base) {
  GstElement *parent = gst_element_get_parent(&base->element);
  GstBin *bin = GST_BIN_CAST (parent);
  GstIterator *iter;
  GstPad *srcpad = NULL;
  GValue data = {0,};
  if (bin) {
    iter = gst_bin_iterate_sources (bin);
    if (gst_iterator_next (iter, &data) == GST_ITERATOR_OK) {
      GstElement *e = g_value_get_object (&data);
      srcpad = gst_element_get_static_pad (e, "src");
      gst_object_unref (e);
      g_value_unset (&data);
    }
    gst_iterator_free (iter);
    gst_object_unref (parent);
  }
  return srcpad;
}

static void
push_result (GstBaseSink * base, DetectResult *result)
{
  GstMapInfo info;
  GstAmlNN *filter = GST_AMLNN (base);
  int i;

  if (result->detect_num <= 0) return;
  if (result->point[0].type != DET_RECTANGLE_TYPE) return;

  if (filter->src_srcpad == NULL) filter->src_srcpad = find_source_pad (base);
  if (filter->src_srcpad == NULL) return;

  int res_size = result->detect_num * sizeof (RDetectPoint_t);
  RDetectPoint_t *pres = (RDetectPoint_t *)g_malloc (res_size);
  if (pres == NULL) return;

  for (i = 0; i < result->detect_num; i++) {
    pres[i].rel_left = result->point[i].point.rectPoint.left;
    pres[i].rel_top = result->point[i].point.rectPoint.top;
    pres[i].rel_right = result->point[i].point.rectPoint.right;
    pres[i].rel_bottom = result->point[i].point.rectPoint.bottom;
  }

  GstBuffer *resbuf = gst_buffer_new_allocate (NULL, res_size, NULL);
  if (!gst_buffer_map (resbuf, &info, GST_MAP_WRITE)) {
    if (pres) g_free (pres);
    return;
  }

  g_memmove (info.data, pres, res_size);
  gst_buffer_unmap (resbuf, &info);
  GstStructure *resst = gst_structure_new ("nn-detection",
      "rectnum", G_TYPE_INT, result->detect_num,
      "rectbuf", GST_TYPE_BUFFER, resbuf,
      NULL);

  GstEvent *nn_detect_event = gst_event_new_custom (GST_EVENT_NN_DETECTED,
      resst);

  gst_pad_push_event (filter->src_srcpad, nn_detect_event);
}

static gpointer
detect_result_process (void *data) {
  DetectResult result;
  GstAmlNN *filter = (GstAmlNN *)data;

  while (filter->_running) {
    g_mutex_lock (&filter->_mutex);
    g_cond_wait (&filter->_cond, &filter->_mutex);

    if (filter->model_type == DET_BUTT) {
      g_mutex_unlock (&filter->_mutex);
      continue;
    }

    if (det_get_result(&result, filter->model_type) == DET_STATUS_OK) {
      push_result (&filter->element, &result);
    }

    g_mutex_unlock (&filter->_mutex);
  }

  return NULL;

}

/* this function does the actual processing
 */
static GstFlowReturn
gst_aml_nn_render (GstBaseSink * base, GstBuffer * outbuf)
{
  GstAmlNN *filter = GST_AMLNN (base);

  if (GST_CLOCK_TIME_IS_VALID (GST_BUFFER_TIMESTAMP (outbuf)))
    gst_object_sync_values (GST_OBJECT (filter), GST_BUFFER_TIMESTAMP (outbuf));

  if (!filter->is_info_set) {
    GST_ELEMENT_ERROR (base, CORE, NEGOTIATION, (NULL), ("unknown format"));
    return GST_FLOW_NOT_NEGOTIATED;
  }

  GstVideoInfo *info = &filter->info;
  GstMapInfo outbuf_info;
  if (info->width != filter->model_width
      || info->height != filter->model_height) {
    return GST_FLOW_OK;
  }

  if (gst_buffer_map (outbuf, &outbuf_info, GST_MAP_READ)) {
    if (g_mutex_trylock (&filter->_mutex)) {
      if (info->width == filter->model_width
          && info->height == filter->model_height) {
        input_image_t im;
        im.data = outbuf_info.data;
        im.pixel_format = PIX_FMT_RGB888;
        im.width = filter->model_width;
        im.height = filter->model_height;
        im.channel = filter->model_channel;
        if (det_set_input (im, filter->model_type) == DET_STATUS_OK) {
          g_cond_signal (&filter->_cond);
        }
      }
      g_mutex_unlock (&filter->_mutex);
    }
    gst_buffer_unmap (outbuf, &outbuf_info);
  }

  return GST_FLOW_OK;
}


/* entry point to initialize the plug-in
 * initialize the plug-in itself
 * register the element factories and other features
 */
static gboolean
amlnn_init (GstPlugin * amlnn)
{
  GST_DEBUG_CATEGORY_INIT (gst_aml_nn_debug, "amlnn", 0,
      "amlogic nn detection element");

  return gst_element_register (amlnn, "amlnn", GST_RANK_PRIMARY,
      GST_TYPE_AMLNN);
}

/* gstreamer looks for this structure to register amlnns
 *
 */
GST_PLUGIN_DEFINE (
    GST_VERSION_MAJOR,
    GST_VERSION_MINOR,
    amlnn,
    "amlogic nn detection plugins",
    amlnn_init,
    VERSION,
    "LGPL",
    "nn detection plugins",
    "http://openlinux.amlogic.com"
)