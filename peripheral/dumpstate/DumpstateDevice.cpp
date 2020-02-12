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

#include <log/log.h>

#include "DumpstateUtil.h"

using android::os::dumpstate::CommandOptions;
using android::os::dumpstate::DumpFileToFd;
using android::os::dumpstate::RunCommandToFd;

namespace android {
namespace hardware {
namespace dumpstate {
namespace V1_0 {
namespace implementation {

// Methods from ::android::hardware::dumpstate::V1_0::IDumpstateDevice follow.
Return<void> DumpstateDevice::dumpstateBoard(const hidl_handle& handle) {
    // NOTE: this is just an example on how to use the DumpstateUtil.h functions to implement
    // this interface - since HIDL_FETCH_IDumpstateDevice() is not defined, this function will never
    // be called by dumpstate.

    if (handle == nullptr || handle->numFds < 1) {
        ALOGE("no FDs\n");
        return Void();
    }

    int fd = handle->data[0];
    if (fd < 0) {
        ALOGE("invalid FD: %d\n", handle->data[0]);
        return Void();
    }

    /* CPU Info */
    DumpFileToFd(fd, "A7-CPU scaling current frequency", "/sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq");
    DumpFileToFd(fd, "A7-CPU scaling governor", "/sys/devices/system/cpu/cpufreq/policy0/scaling_governor");
    DumpFileToFd(fd, "A7-CPU available frequencies", "/sys/devices/system/cpu/cpufreq/policy0/scaling_available_frequencies");

    /* IO Memory mapping */
    RunCommandToFd(fd, "Proc. IOMEM.", {"/vendor/bin/sh", "-c", "cat /proc/iomem"}, CommandOptions::AS_ROOT);

    /* Interrupts List */
    DumpFileToFd(fd, "Proc. Interrupts", "/proc/interrupts");

    /* GPIOs config */
    DumpFileToFd(fd, "GPIOs", "/sys/kernel/debug/gpio");

    /* Clocks config */
    DumpFileToFd(fd, "CLKs", "/sys/kernel/debug/clk/clk_summary");

    /* Regulator config */
    DumpFileToFd(fd, "Regulators", "/sys/kernel/debug/regulator/regulator_summary");

    /* Pin Ctrl config */
    DumpFileToFd(fd, "PINCtrl", "/sys/kernel/debug/pinctrl/pinctrl-handles");

    /* PINs Configs */
    RunCommandToFd(fd, "PINs config.", {"/vendor/bin/sh", "-c", "for p in $(ls -d /sys/kernel/debug/pinctrl/*/); do echo -s \"$p: `cat $p/pinconf-pins`\"; done"}, CommandOptions::AS_ROOT);

    return Void();
}

}  // namespace implementation
}  // namespace V1_0
}  // namespace dumpstate
}  // namespace hardware
}  // namespace android
