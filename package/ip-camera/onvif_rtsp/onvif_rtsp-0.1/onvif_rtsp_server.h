#ifndef _ONVIF_RTSP_SERVER_
#define _ONVIF_RTSP_SERVER_

#include <gst/gst.h>
#ifdef __cplusplus
extern "C" {
#endif
#include <gst/rtsp-server/rtsp-onvif-server.h>
#ifdef __cplusplus
}
#endif
#include "onvif_rtsp_config.h"


typedef struct rtsp_server {
  GMainLoop *loop;
  GstRTSPServer *server;
  GstRTSPMountPoints *mounts;
  GstRTSPMediaFactory *factory;
  GstRTSPAuth *auth;
  GstRTSPToken *token;
  gchar *basic;

  std::shared_ptr<RTSP_CONFIG_t> config;
} RTSP_SERVER_t;

bool rtsp_server_init(RTSP_SERVER_t *serv);
bool rtsp_server_start(RTSP_SERVER_t *serv);

#endif /* _ONVIF_RTSP_SERVER_ */
