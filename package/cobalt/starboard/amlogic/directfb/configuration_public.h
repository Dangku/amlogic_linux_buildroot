// Copyright 2018 The Cobalt Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// The Starboard configuration for Desktop X86 Linux. Other devices will have
// specific Starboard implementations, even if they ultimately are running some
// version of Linux.

// Other source files should never include this header directly, but should
// include the generic "starboard/configuration.h" instead.

#ifndef THIRD_PARTY_STARBOARD_AMLOGIC_DIRECTFB_CONFIGURATION_PUBLIC_H_
#define THIRD_PARTY_STARBOARD_AMLOGIC_DIRECTFB_CONFIGURATION_PUBLIC_H_

// --- Architecture Configuration --------------------------------------------

// Whether the current platform is big endian. SB_IS_LITTLE_ENDIAN will be
// automatically set based on this.
#define SB_IS_BIG_ENDIAN 0

// Whether the current platform is an ARM architecture.
#define SB_IS_ARCH_ARM 1

// Whether the current platform is a MIPS architecture.
#define SB_IS_ARCH_MIPS 0

// Whether the current platform is a PPC architecture.
#define SB_IS_ARCH_PPC 0

// Whether the current platform is an x86 architecture.
#define SB_IS_ARCH_X86 0

// Whether the current platform is a 32-bit architecture.
#if defined(__arm__)
#define SB_IS_32_BIT 1
#else
#define SB_IS_32_BIT 0
#endif

// Whether the current platform is a 64-bit architecture.
#if defined(__aarch64__)
#define SB_IS_64_BIT 1
#else
#define SB_IS_64_BIT 0
#endif

// Whether the current platform's pointers are 32-bit.
// Whether the current platform's longs are 32-bit.
#if SB_IS(32_BIT)
#define SB_HAS_32_BIT_POINTERS 1
#define SB_HAS_32_BIT_LONG 1
#else
#define SB_HAS_32_BIT_POINTERS 0
#define SB_HAS_32_BIT_LONG 0
#endif

// Whether the current platform's pointers are 64-bit.
// Whether the current platform's longs are 64-bit.
#if SB_IS(64_BIT)
#define SB_HAS_64_BIT_POINTERS 1
#define SB_HAS_64_BIT_LONG 1
#else
#define SB_HAS_64_BIT_POINTERS 0
#define SB_HAS_64_BIT_LONG 0
#endif

// Configuration parameters that allow the application to make some general
// compile-time decisions with respect to the the number of cores likely to be
// available on this platform. For a definitive measure, the application should
// still call SbSystemGetNumberOfProcessors at runtime.

// Whether the current platform is expected to have many cores (> 6), or a
// wildly varying number of cores.
#define SB_HAS_MANY_CORES 1

// Whether the current platform is expected to have exactly 1 core.
#define SB_HAS_1_CORE 0

// Whether the current platform is expected to have exactly 2 cores.
#define SB_HAS_2_CORES 0

// Whether the current platform is expected to have exactly 4 cores.
#define SB_HAS_4_CORES 0

// Whether the current platform is expected to have exactly 6 cores.
#define SB_HAS_6_CORES 0

// Whether the current platform's thread scheduler will automatically balance
// threads between cores, as opposed to systems where threads will only ever run
// on the specifically pinned core.
#define SB_HAS_CROSS_CORE_SCHEDULER 1

// --- Graphics Configuration ------------------------------------------------

// Indicates whether or not the given platform supports rendering of NV12
// textures. These textures typically originate from video decoders.
#define SB_HAS_NV12_TEXTURE_SUPPORT 1

// Whether the current platform has speech synthesis.
#define SB_HAS_SPEECH_SYNTHESIS 0

// Include the Linux configuration that's common between all Desktop Linuxes.
#include "third_party/starboard/amlogic/shared/configuration_public.h"

// The current platform has microphone supported.
#undef SB_HAS_MICROPHONE
#define SB_HAS_MICROPHONE 1

#if SB_API_VERSION >= 8
// Whether the current platform implements the on screen keyboard interface.
#define SB_HAS_ON_SCREEN_KEYBOARD 0

// Whether the current platform uses a media player that relies on a URL.
#define SB_HAS_PLAYER_WITH_URL 0
#endif  // SB_API_VERSION >= 8

// Indicates whether or not the given platform supports rendering of NV12
// textures. These textures typically originate from video decoders.
#undef SB_HAS_NV12_TEXTURE_SUPPORT
#define SB_HAS_NV12_TEXTURE_SUPPORT 0

// This configuration supports the blitter API (implemented via DirectFB).
#undef SB_HAS_BLITTER
#define SB_HAS_BLITTER 1

// Unfortunately, DirectFB does not support bilinear filtering.  According to
// http://osdir.com/ml/graphics.directfb.user/2008-06/msg00028.html, "smooth
// scaling is not supported in conjunction with blending", and we need blending
// more.
#undef SB_HAS_BILINEAR_FILTERING_SUPPORT
#define SB_HAS_BILINEAR_FILTERING_SUPPORT 0

// DirectFB's only 32-bit RGBA color format is word-order ARGB.  This translates
// to byte-order ARGB for big endian platforms and byte-order BGRA for
// little-endian platforms.
#undef SB_PREFERRED_RGBA_BYTE_ORDER
#if SB_IS(BIG_ENDIAN)
#define SB_PREFERRED_RGBA_BYTE_ORDER SB_PREFERRED_RGBA_BYTE_ORDER_ARGB
#else
#define SB_PREFERRED_RGBA_BYTE_ORDER SB_PREFERRED_RGBA_BYTE_ORDER_BGRA
#endif

#define SB_HAS_GLES2 0

#endif  // THIRD_PARTY_STARBOARD_AMLOGIC_DIRECTFB_CONFIGURATION_PUBLIC_H_
