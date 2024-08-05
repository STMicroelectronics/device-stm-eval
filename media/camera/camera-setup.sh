#!/vendor/bin/sh

#######################################
# Constants
#######################################

FPS=30

# Preview configuration (aux)
PREVIEWWIDTH=640
PREVIEWHEIGHT=480
PREVIEWFMT=RGB16
previewbuscode=RGB565_2X8_LE

# Record configuration (main)
ENCWIDTH=1024
ENCHEIGHT=768
ENCFMT=YUY2
encodebuscode=YUYV8_2X8

# list of accepted formats (TODO: reduce to the most used values)
MEDIA_BUS_FORMAT_LIST="RGB444_1X12 RGB444_2X8_PADHI_BE RGB444_2X8_PADHI_LE RGB555_2X8_PADHI_BE RGB555_2X8_PADHI_LE"
MEDIA_BUS_FORMAT_LIST+=" RGB565_1X16 BGR565_2X8_BE BGR565_2X8_LE RGB565_2X8_BE RGB565_2X8_LE RGB666_1X18 RBG888_1X24 RGB666_1X24_CPADHI RGB666_1X7X3_SPWG"
MEDIA_BUS_FORMAT_LIST+=" BGR888_1X24 BGR888_3X8 GBR888_1X24 RGB888_1X24 RGB888_2X12_BE RGB888_2X12_LE RGB888_3X8 RGB888_3X8_DELTA RGB888_1X7X4_SPWG"
MEDIA_BUS_FORMAT_LIST+=" RGB888_1X7X4_JEIDA ARGB8888_1X32 RGB888_1X32_PADHI RGB101010_1X30 RGB121212_1X36 RGB161616_1X48"
MEDIA_BUS_FORMAT_LIST+=" Y8_1X8 UV8_1X8 UYVY8_1_5X8 VYUY8_1_5X8 YUYV8_1_5X8 YVYU8_1_5X8 UYVY8_2X8 VYUY8_2X8 YUYV8_2X8 YVYU8_2X8"
MEDIA_BUS_FORMAT_LIST+=" Y10_1X10 Y10_2X8_PADHI_LE UYVY10_2X10 VYUY10_2X10 YUYV10_2X10 YVYU10_2X10"
MEDIA_BUS_FORMAT_LIST+=" Y12_1X12 UYVY12_2X12 VYUY12_2X12 YUYV12_2X12 YVYU12_2X12 Y14_1X14 UYVY8_1X16 VYUY8_1X16 YUYV8_1X16 YVYU8_1X16"
MEDIA_BUS_FORMAT_LIST+=" YDYUYDYV8_1X16 UYVY10_1X20 VYUY10_1X20 YUYV10_1X20 YVYU10_1X20 VUY8_1X24 YUV8_1X24 UYYVYY8_0_5X24"
MEDIA_BUS_FORMAT_LIST+=" UYVY12_1X24 VYUY12_1X24 YUYV12_1X24 YVYU12_1X24 YUV10_1X30 UYYVYY10_0_5X30 AYUV8_1X32 UYYVYY12_0_5X36 YUV12_1X36 YUV16_1X48 UYYVYY16_0_5X48"
MEDIA_BUS_FORMAT_LIST+=" SBGGR8_1X8 SGBRG8_1X8 SGRBG8_1X8 SRGGB8_1X8 SBGGR10_ALAW8_1X8 SGBRG10_ALAW8_1X8 SGRBG10_ALAW8_1X8 SRGGB10_ALAW8_1X8"
MEDIA_BUS_FORMAT_LIST+=" SBGGR10_DPCM8_1X8 SGBRG10_DPCM8_1X8 SGRBG10_DPCM8_1X8 SRGGB10_DPCM8_1X8 SBGGR10_2X8_PADHI_BE SBGGR10_2X8_PADHI_LE SBGGR10_2X8_PADLO_BE SBGGR10_2X8_PADLO_LE"
MEDIA_BUS_FORMAT_LIST+=" SBGGR10_1X10 SGBRG10_1X10 SGRBG10_1X10 SRGGB10_1X10 SBGGR12_1X12 SGBRG12_1X12 SGRBG12_1X12 SRGGB12_1X12"
MEDIA_BUS_FORMAT_LIST+=" SBGGR14_1X14 SGBRG14_1X14 SGRBG14_1X14 SRGGB14_1X14 SBGGR16_1X16 SGBRG16_1X16 SGRBG16_1X16 SRGGB16_1X16 JPEG_1X8"

# Mix possible values for width and height (TODO: add check by pair)
MEDIA_BUS_SIZE_LIST= "4096 3840 3280 2560 2464 2160 1920 1640 1440 1280 1232 1080 1024 768 720 640 480 320 240 176 144"

#######################################
# Variables
#######################################
do_verbose=0
do_update=0

aux_width=$PREVIEWWIDTH
aux_height=$PREVIEWHEIGHT
aux_format=$previewbuscode

main_width=$ENCWIDTH
main_height=$ENCHEIGHT
main_format=$encodebuscode

#######################################
# Functions
#######################################

#######################################
# Check if item is available in list
# Globals:
#   None
# Arguments:
#   $1 = list of possible items
#   $2 = item which shall be tested
# Returns:
#   0 if item found in list
#   1 if item not found in list
#######################################
in_list()
{
  local list="$1"
  local checked_item="$2"

  for item in ${list}
  do
    if [[ "$item" == "$checked_item" ]]; then
      return 0
    fi
  done

  return 1
}

#######################################
# Execute command, manage verbosity
# Globals:
#   None
# Arguments:
#   $1 = command to be executed
# Returns:
#   None
#######################################
cmd() {
    cmd=$1
    if [[ ${do_verbose} == 1 ]]; then
        echo "camerasetup: ${cmd}" >>/dev/kmsg
    fi
    eval ${cmd} > /dev/null 2>&1
}

#######################################
# Check dcmipp availability, set device properties in consequence
# Globals:
#   DCMIPP_SENSOR = sensor name or "NOT FOUND"
# Arguments:
#   None
# Returns:
#   None
#######################################
is_dcmipp_present() {
    DCMIPP_SENSOR="NOTFOUND"
    for video in $(find /sys/class/video4linux -name "video*" -type l);
    do
        if [ "$(cat ${video}/name)" = "dcmipp_aux_capture" ]; then
            V4L_PREVIEWDEVICE="/dev/$(basename $video)"
            if [[ ${do_verbose} == 1 ]]; then
                echo "camerasetup: preview video device (aux)="${V4L_PREVIEWDEVICE} >>/dev/kmsg
            fi
            setprop vendor.camera.aux.device ${V4L_PREVIEWDEVICE}
        fi
        if [ "$(cat ${video}/name)" = "dcmipp_main_capture" ]; then

            cd ${video}/device/
            mediadev=/dev/$(ls -d media*)
            cd -

            setprop vendor.camera.media.device ${mediadev}

            for sub in $(find /sys/class/video4linux -name "v4l-subdev*" -type l);
            do
                subdev_name=$(tr -d '\0' < $sub/name | awk '{print $1}')
                #HFR FIXME get rid of driver name
                if [ "${subdev_name}" = "gc2145" ] || [ "${subdev_name}" = "ov5640" ] || [ "${subdev_name}" = "imx335" ]; then
                    DCMIPP_SENSOR=${subdev_name}

                    V4L_ENCDEVICE="/dev/$(basename $video)"
                    if [[ ${do_verbose} == 1 ]]; then
                        echo "camerasetup: encoder video device (main)="${V4L_ENCDEVICE} >>/dev/kmsg
                    fi

                    setprop vendor.camera.main.device ${V4L_ENCDEVICE}

                    sensorsubdev="$(tr -d '\0' < $sub/name)"
                    sensordev=$(media-ctl -d ${mediadev} -p -e "${sensorsubdev}" | grep "node name" | awk -F\name '{print $2}')
                    #interface is connected to input of isp (":1 [ENABLED" with media-ctl -p)
                    interfacesubdev=$(media-ctl -d ${mediadev} -p -e "dcmipp_main_isp" | grep ":1 \[ENABLED" | awk -F\" '{print $2}')
                    if [[ ${do_verbose} == 1 ]]; then
                        echo "camerasetup: mediadev=\""${mediadev}\" >>/dev/kmsg # /dev/media2
                        echo "camerasetup: sensorsubdev=\""${sensorsubdev}\" >>/dev/kmsg # imx335 0-001a
                        echo "camerasetup: sensordev=\""${sensordev}\" >>/dev/kmsg # /dev/v4l-subdev6
                        echo "camerasetup: interfacesubdev=\""${interfacesubdev}\" >>/dev/kmsg # stm32_csi2host.48020000.csi2hos
                    fi
                fi
            done
        fi
    done
}

#######################################
# Getback main capture required configuration from properties
# Globals:
#   O main_width = required width for main capture
#   O main_height = required height for main capture
#   O main_format = required format for main capture
# Arguments:
#   None
# Returns:
#   None
#######################################
get_main_config() {

    # TODO: add check of width value
    width=`getprop vendor.camera.main.width`
    if [ ${width} = *[![:blank:]]* ]; then
        if ! in_list "${MEDIA_BUS_SIZE_LIST}" "${width}"; then
            echo "camerasetup: ERROR: unauthorized value \"${width}\" for main width, keep current value \"${main_width}\"" >>/dev/kmsg
        else
            main_width=${width}
        fi
    fi

    # TODO: add check of height value
    height=`getprop vendor.camera.main.height`
    if [ ${height} = *[![:blank:]]* ]; then
        if ! in_list "${MEDIA_BUS_SIZE_LIST}" "${height}"; then
            echo "camerasetup: ERROR: unauthorized value \"${height}\" for main height, keep current value \"${main_height}\"" >>/dev/kmsg
        else
            main_height=${height}
        fi
    fi

    format=`getprop vendor.camera.main.format`
    if [ ${format} = *[![:blank:]]* ]; then
        if ! in_list "${MEDIA_BUS_FORMAT_LIST}" "${format}"; then
            echo "camerasetup: ERROR: unknown format \"${format}\" for main, keep current value \"${main_format}\"" >>/dev/kmsg
        else
            main_format=${format}
        fi
    fi
    if [[ ${do_verbose} == 1 ]]; then
        echo "camerasetup: getprop main_width=\"${width}\"" >>/dev/kmsg
        echo "camerasetup: getprop main_height=\"${height}\"" >>/dev/kmsg
        echo "camerasetup: getprop main_format=\"${format}\"" >>/dev/kmsg
    fi
}

#######################################
# Getback aux capture required configuration from properties
# Globals:
#   O aux_width = required width for aux capture
#   O aux_height = required height for aux capture
#   O aux_format = required format for aux capture
# Arguments:
#   None
# Returns:
#   None
#######################################
get_aux_config() {

    # TODO: add check of width value
    width=`getprop vendor.camera.aux.width`
    if [ ${width} = *[![:blank:]]* ]; then
        if ! in_list "${MEDIA_BUS_SIZE_LIST}" "${width}"; then
            echo "camerasetup: ERROR: unauthorized value \"${width}\" for aux width, keep current value \"${aux_width}\"" >>/dev/kmsg
        else
            aux_width=${width}
        fi
    fi

    # TODO: add check of height value
    height=`getprop vendor.camera.aux.height`
    if [ ${height} = *[![:blank:]]* ]; then
        if ! in_list "${MEDIA_BUS_SIZE_LIST}" "${height}"; then
            echo "camerasetup: ERROR: unauthorized value \"${height}\" for aux height, keep current value \"${aux_height}\"" >>/dev/kmsg
        else
            aux_height=${height}
        fi
    fi

    format=`getprop vendor.camera.aux.format`
    if [ ${format} = *[![:blank:]]* ]; then
        if ! in_list "${MEDIA_BUS_FORMAT_LIST}" "${format}"; then
            echo "camerasetup: ERROR: unknown format ${format} for aux, keep current value: ${aux_format}" >>/dev/kmsg
        else
            aux_format=$format
        fi
    fi
    if [[ ${do_verbose} == 1 ]]; then
        echo "camerasetup: getprop aux_width=\"${width}\"" >>/dev/kmsg
        echo "camerasetup: getprop aux_height=\"${height}\"" >>/dev/kmsg
        echo "camerasetup: getprop aux_format=\"${format}\"" >>/dev/kmsg
    fi
}

#######################################
# Initialise the camera pipe
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
init_camera() {
    # Use sensor in raw-bayer format
    sensorbuscode=`v4l2-ctl --list-subdev-mbus-codes -d ${sensordev} | grep SRGGB | awk -FMEDIA_BUS_FMT_ '{print $2}'`
    if [[ ${do_verbose} == 1 ]]; then
        echo "camerasetup: sensor buscode="${sensorbuscode} >>/dev/kmsg # SRGGB10_1X10
    fi

    sensor_width=0
    sensor_height=0
    if [ "${DCMIPP_SENSOR}" = "ov5640" ]; then
        # OV5640 only support 720p with raw-bayer format
        sensor_width=1280
        sensor_height=720
        # OV5640 claims to support all raw bayer combinations but always output SBGGR8_1X8...
        sensorbuscode=SBGGR8_1X8
    elif [ "${DCMIPP_SENSOR}" = "imx335" ]; then
        v4l2-ctl -d ${sensordev} -c exposure=4490
        # Do exposure correction continuously in background
        # TODO : integrate isp binary in Android
        # sleep 2  && while : ; do /usr/bin/isp -w > /dev/null ; done &
    fi

    # Let sensor return its prefered resolution & format === TO BE CHECKED
    cmd "  media-ctl -d ${mediadev} --set-v4l2 \"'${sensorsubdev}':0[fmt:${sensorbuscode}/${sensor_width}x${sensor_height}@1/${FPS} field:none]\""
    sensor_format=`media-ctl -d ${mediadev} --get-v4l2 "'${sensorsubdev}':0" | awk -F"fmt:" '{print $2}' | awk -F" " '{print $1}'`
    sensor_width=`echo ${sensor_format} | awk -F"/" '{print $2}' | awk -F"x" '{print $1}'`
    sensor_height=`echo ${sensor_format} | awk -F"/" '{print $2}' | awk -F"x" '{print $2}' | awk -F" " '{print $1}' | awk -F"@" '{print $1}'`

    if [[ ${do_verbose} == 1 ]]; then
        echo "camerasetup: sensor width = "${sensor_width} >>/dev/kmsg # 2592
        echo "camerasetup: sensor height = "${sensor_height} >>/dev/kmsg # 1940

        echo "camerasetup: Mediacontroller graph:" >>/dev/kmsg
    fi

    # Use main pipe for ISP debayering and image correction
    cmd "  media-ctl -d ${mediadev} --set-v4l2 \"'${sensorsubdev}':0[fmt:${sensorbuscode}/${sensor_width}x${sensor_height}@1/${FPS} field:none]\""
    cmd "  media-ctl -d ${mediadev} --set-v4l2 \"'${interfacesubdev}':1[fmt:${sensorbuscode}/${sensor_width}x${sensor_height}]\""
    cmd "  media-ctl -d ${mediadev} --set-v4l2 \"'dcmipp_main_isp':1[fmt:RGB888_1X24/${sensor_width}x${sensor_height} field:none]\""
    # Main pipe downscale and color conversion is used to fit video encoder format/resolution
    cmd "  media-ctl -d ${mediadev} --set-v4l2 \"'dcmipp_main_postproc':0[compose:(0,0)/${main_width}x${main_height}]\""
    cmd "  media-ctl -d ${mediadev} --set-v4l2 \"'dcmipp_main_postproc':1[fmt:${main_format}/${main_width}x${main_height}]\" -v"

    #Aux pipe is linked to output of main ISP to inherit of image correction
    cmd "  media-ctl -d ${mediadev} -l '\"stm32_csi2host.48020000.csi2hos\":1->\"dcmipp_aux_postproc\":0[0]' -v"
    cmd "  media-ctl -d ${mediadev} -l '\"dcmipp_main_isp\":2->\"dcmipp_aux_postproc\":0[1]' -v"
    #Aux pipe downscale is used to fit display preview format/resolution
    cmd "  media-ctl -d ${mediadev} --set-v4l2 \"'dcmipp_aux_postproc':0[compose:(0,0)/${aux_width}x${aux_height}]\""
    cmd "  media-ctl -d ${mediadev} --set-v4l2 \"'dcmipp_aux_postproc':1[fmt:${aux_format}/${aux_width}x${aux_height}]\" -v"

}

#######################################
# Update the camera pipe (main)
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
update_main_camera() {
    cmd "  media-ctl -d ${mediadev} --set-v4l2 \"'dcmipp_main_postproc':0[compose:(0,0)/${main_width}x${main_height}]\""
    cmd "  media-ctl -d ${mediadev} --set-v4l2 \"'dcmipp_main_postproc':1[fmt:${main_format}/${main_width}x${main_height}]\" -v"
}

#######################################
# Update the camera pipe (aux)
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
update_aux_camera() {
    cmd "  media-ctl -d ${mediadev} --set-v4l2 \"'dcmipp_aux_postproc':0[compose:(0,0)/${aux_width}x${aux_height}]\""
    cmd "  media-ctl -d ${mediadev} --set-v4l2 \"'dcmipp_aux_postproc':1[fmt:${aux_format}/${aux_width}x${aux_height}]\" -v"
}

#######################################
# Main
#######################################

# Ensure that the script is being executed in a directory that it has permission to access
cd /vendor/bin
while test "$1" != ""; do
  arg=$1
  case $arg in

    "-v"|"--verbose" )
      do_verbose=1
      ;;

    "-u"|"--update" )
      do_update=1
      ;;

    ** )
      ;;
  esac
  shift
done

if [[ ${do_update} == 1 ]]; then
    mediadev=`getprop vendor.camera.media.device`
    if [ ${mediadev} = *[![:blank:]]* ]; then
        camera_update=`getprop vendor.camera.update.config`
        if [[ ${camera_update} == "main" ]] || [[ ${camera_update} == "all" ]]; then
            get_main_config
            update_main_camera
        fi
        if [[ ${camera_update} == "aux" ]] || [[ ${camera_update} == "all" ]]; then
            get_aux_config
            update_aux_camera
        fi
    else
        echo "camerasetup: ERROR: camera update required while no media device available (missing init ?)" >>/dev/kmsg
    fi
else
    # camera detection
    is_dcmipp_present
    if [ "$DCMIPP_SENSOR" != "NOTFOUND" ]; then
        get_main_config
        get_aux_config
        init_camera
    fi
fi

setprop vendor.camera.update 0
cd -
