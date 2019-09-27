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

    /* CPU 0 Info */
    DumpFileToFd(fd, "A7-CPU0 Scaling Min. Freq.", "/sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq");
    RunCommandToFd(fd, "A7-CPU0 Scaling Max. Freq.", {"/system/bin/sh", "-c", "cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq"}, CommandOptions::AS_ROOT);
    RunCommandToFd(fd, "A7-CPU0 Scaling Governor", {"/system/bin/sh", "-c", "cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"}, CommandOptions::AS_ROOT);
    RunCommandToFd(fd, "A7-CPU0 OPP List", {"/system/bin/sh", "-c", "ls /sys/kernel/debug/opp/cpu0"}, CommandOptions::AS_ROOT);

    /* CPU 1 Info */
    DumpFileToFd(fd, "A7-CPU1 Scaling Min. Freq.", "/sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq");
    RunCommandToFd(fd, "A7-CPU1 Scaling Max. Freq.", {"/system/bin/sh", "-c", "cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq"}, CommandOptions::AS_ROOT);
    RunCommandToFd(fd, "A7-CPU1 Scaling Governor", {"/system/bin/sh", "-c", "cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor"}, CommandOptions::AS_ROOT);
    RunCommandToFd(fd, "A7-CPU1 OPP List", {"/system/bin/sh", "-c", "ls /sys/kernel/debug/opp/cpu1"}, CommandOptions::AS_ROOT);

    /* IO Memory mapping */
    RunCommandToFd(fd, "Proc. IOMEM.", {"/system/bin/sh", "-c", "cat /proc/iomem"}, CommandOptions::AS_ROOT);

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
    RunCommandToFd(fd, "PINs config.", {"/system/bin/sh", "-c", "for p in $(ls -d /sys/kernel/debug/pinctrl/*/); do echo -s \"$p: `cat $p/pinconf-pins`\"; done"}, CommandOptions::AS_ROOT);

    return Void();
}

}  // namespace implementation
}  // namespace V1_0
}  // namespace dumpstate
}  // namespace hardware
}  // namespace android
