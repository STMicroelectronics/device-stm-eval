/*
 * Copyright (C) 2019 The Android Open Source Project
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

#include <recovery_ui/device.h>
#include <recovery_ui/screen_ui.h>

namespace android {
namespace device {
namespace stm {
namespace eval {

constexpr const char* BRIGHTNESS_FILE_STM =
    "/sys/class/backlight/panel-lvds-backlight/brightness";
constexpr const char* MAX_BRIGHTNESS_FILE_STM =
    "/sys/class/backlight/panel-lvds-backlight/max_brightness";

class ValidUI : public ::ScreenRecoveryUI
{

    bool Init(const std::string& locale) {
        // Basic brightness mechanism = only 1 (100%) or 0
        brightness_normal_ = 100.0;
        brightness_dimmed_ = 100.0;

        brightness_file_ = BRIGHTNESS_FILE_STM;
        max_brightness_file_ = MAX_BRIGHTNESS_FILE_STM;

        return ScreenRecoveryUI::Init(locale);
    }

    ScreenRecoveryUI::KeyAction CheckKey(int key, bool is_long_press) {
        // Recovery core can't tolerate using KEY_POWER as an alias for
        // KEY_DOWN, and a reboot is always triggered. Remap any power
        // key press to KEY_DOWN to allow us to use the power key as
        // a regular key.
        if (key == KEY_POWER && !is_long_press) {
            ScreenRecoveryUI::EnqueueKey(KEY_DOWN);
            return ScreenRecoveryUI::IGNORE;
        }

        return ScreenRecoveryUI::CheckKey(key, is_long_press);
    }
};

} // namespace eval
} // namespace stm
} // namespace device
} // namespace android

Device *make_device()
{
    return new Device(new ::android::device::stm::eval::ValidUI());
}
