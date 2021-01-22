/*
 * Copyright (C) 2016 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "dumpstate"

#include "DumpstateDevice.h"

#include <android-base/properties.h>
#include <android-base/unique_fd.h>
#include <cutils/properties.h>
#include <hidl/HidlBinderSupport.h>
#include <hidl/HidlSupport.h>

#include <log/log.h>

#include "DumpstateUtil.h"

#define VENDOR_VERBOSE_LOGGING_ENABLED_PROPERTY "persist.vendor.verbose_logging_enabled"

using android::os::dumpstate::CommandOptions;
using android::os::dumpstate::DumpFileToFd;
using android::os::dumpstate::RunCommandToFd;

namespace android {
namespace hardware {
namespace dumpstate {
namespace V1_1 {
namespace implementation {

static void DumpCpu(int fd) {
    const std::string dir = "/sys/devices/system/cpu/cpufreq/policy0/";
    const std::vector<std::string> files {
        "scaling_cur_freq",
        "scaling_governor",
        "scaling_available_frequencies",
    };

    for (const auto &file : files) {
        DumpFileToFd(fd, "A7-CPU "+file , dir+file);
    }
}

// Methods from ::android::hardware::dumpstate::V1_0::IDumpstateDevice follow.
Return<void> DumpstateDevice::dumpstateBoard(const hidl_handle& handle) {
    // Ignore return value, just return an empty status.
    dumpstateBoard_1_1(handle, DumpstateMode::DEFAULT, 30 * 1000 /* timeoutMillis */);
    return Void();
}

// Methods from ::android::hardware::dumpstate::V1_1::IDumpstateDevice follow.
Return<DumpstateStatus> DumpstateDevice::dumpstateBoard_1_1(const hidl_handle& handle,
                                                            const DumpstateMode mode,
                                                            const uint64_t timeoutMillis) {

    // Unused arguments.
    (void) timeoutMillis;

    // Exit when dump is completed since this is a lazy HAL.
    addPostCommandTask([]() {
        exit(0);
    });

    if (handle == nullptr || handle->numFds < 1) {
        ALOGE("no FDs\n");
        return DumpstateStatus::ILLEGAL_ARGUMENT;
    }

    int fd = handle->data[0];
    if (fd < 0) {
        ALOGE("invalid FD: %d\n", handle->data[0]);
        return DumpstateStatus::ILLEGAL_ARGUMENT;
    }

    bool isModeValid = false;
    for (const auto dumpstateMode : hidl_enum_range<DumpstateMode>()) {
        if (mode == dumpstateMode) {
            isModeValid = true;
            break;
        }
    }
    if (!isModeValid) {
        ALOGE("Invalid mode: %d\n", mode);
        return DumpstateStatus::ILLEGAL_ARGUMENT;
    } else if (mode == DumpstateMode::WEAR) {
        // We aren't a Wear device.
        ALOGE("Unsupported mode: %d\n", mode);
        return DumpstateStatus::UNSUPPORTED_MODE;
    }

    /* Properties */
    RunCommandToFd(fd, "VENDOR PROPERTIES", {"/vendor/bin/getprop"});

    /* CPU Info */
    DumpCpu(fd);

    /* Temperature */
    RunCommandToFd(fd, "TEMPERATURE", {"/vendor/bin/sh", "-c", "for f in /sys/class/thermal/thermal_zone* ; do type=`cat $f/type` ; temp=`cat $f/temp` ; echo \"$type: $temp\" ; done"});

    /* IO Memory mapping */
    RunCommandToFd(fd, "IOMEM", {"/vendor/bin/sh", "-c", "cat /proc/iomem"}, CommandOptions::AS_ROOT);

    /* Memory Info */
    DumpFileToFd(fd, "MEMORY INFO", "/proc/meminfo");

    /* Interrupts List */
    DumpFileToFd(fd, "INTERRUPTS", "/proc/interrupts");

#ifdef DEBUGFS

    /* GPIOs config */
    DumpFileToFd(fd, "GPIOS", "/sys/kernel/debug/gpio");

    /* Clocks config */
    DumpFileToFd(fd, "CLOCKS", "/sys/kernel/debug/clk/clk_summary");

    /* Regulator config */
    DumpFileToFd(fd, "REGULATORS", "/sys/kernel/debug/regulator/regulator_summary");

    /* Pin Ctrl config */
    DumpFileToFd(fd, "PIN CONTROL", "/sys/kernel/debug/pinctrl/pinctrl-handles");

    /* PINs Configs */
    RunCommandToFd(fd, "PIN CONFIG", {"/vendor/bin/sh", "-c", "for p in $(ls -d /sys/kernel/debug/pinctrl/*/); do echo -s \"$p: `cat $p/pinconf-pins`\"; done"}, CommandOptions::AS_ROOT);

#endif

    return DumpstateStatus::OK;
}

Return<void> DumpstateDevice::setVerboseLoggingEnabled(const bool enable) {
    android::base::SetProperty(VENDOR_VERBOSE_LOGGING_ENABLED_PROPERTY, enable ? "true" : "false");
    return Void();
}

Return<bool> DumpstateDevice::getVerboseLoggingEnabled() {
    return android::base::GetBoolProperty(VENDOR_VERBOSE_LOGGING_ENABLED_PROPERTY, false);
}

}  // namespace implementation
}  // namespace V1_1
}  // namespace dumpstate
}  // namespace hardware
}  // namespace android
