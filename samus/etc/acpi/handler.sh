#!/bin/bash
# Default acpi script that takes an entry for all actions

function _SwitchPulsePort () {
    sink="alsa_output.platform-bdw-rt5677.analog-stereo"
    port="analog-output-speaker"
 
    if [ "x$1" == "xplug" ] ; then
        port="analog-output-headphones"
    fi
 
    for user in `ps axc -o user,command | grep pulseaudio | cut -f1 -d' ' | sort | uniq`
    do
        uid=`id -u "${user}"`
        pulsepath="/run/user/${uid}/pulse/"
        su "${user}" -c - "PULSE_RUNTIME_PATH=\"${pulsepath}\" pacmd set-sink-port ${sink} ${port}"
    done
}


logger "ACPID: $0: $1 $2 $3"
case "$1" in
    jack/headphone)
        logger "$0: $1 $2 $3"
        case "$3" in
           plug)
               logger "$0: headphone plugged"
               _SwitchPulsePort "$3"
               ;;
           unplug)
               logger "$0: headphone unplugged"
               _SwitchPulsePort "$3"
               ;;
           *)
               logger "ACPI action undefined: $3"
               ;;
        esac
        ;;
  button/power)
    case "$2" in
      PBTN|PWRF)
        logger 'PowerButton pressed'
        ;;
      *)
        logger "ACPI action undefined: $2"
        ;;
    esac
    ;;
  button/sleep)
    case "$2" in
      SLPB|SBTN)
        logger 'SleepButton pressed'
        ;;
      *)
        logger "ACPI action undefined: $2"
        ;;
    esac
    ;;
  ac_adapter)
    case "$2" in
      AC|ACAD|ADP0)
        case "$4" in
          00000000)
            logger 'AC unpluged'
            ;;
          00000001)
            logger 'AC pluged'
            ;;
        esac
        ;;
      *)
        logger "ACPI action undefined: $2"
        ;;
    esac
    ;;
  battery)
    case "$2" in
      BAT0)
        case "$4" in
          00000000)
            logger 'Battery online'
            ;;
          00000001)
            logger 'Battery offline'
            ;;
        esac
        ;;
      CPU0)
        ;;
      *)  logger "ACPI action undefined: $2" ;;
    esac
    ;;
  button/lid)
    case "$3" in
      close)
        logger 'LID closed'
        ;;
      open)
        logger 'LID opened'
        ;;
      *)
        logger "ACPI action undefined: $3"
        ;;
    esac
    ;;
  *)
    logger "ACPI group/action undefined: $1 / $2"
    ;;
esac

# vim:set ts=2 sw=2 ft=sh et:
