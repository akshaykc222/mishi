enum BottomAppItems { home, search, downloads, premium }

enum AudioStatus { downloading, canPlay, playing, pause, stop }

AudioStatus getAudioStatusFromString(String value) {
  switch (value) {
    case 'downloading':
      return AudioStatus.downloading;
    case 'canPlay':
      return AudioStatus.canPlay;
    case 'playing':
      return AudioStatus.playing;
    case 'pause':
      return AudioStatus.pause;
    case 'stop':
      return AudioStatus.stop;

    default:
      return AudioStatus.canPlay;
  }
}

var timingList = [
  "infinite",
  "10 mins",
  "20 mins",
  "30 mins",
  "40 mins",
  "1 hour",
  "2 hour",
  "4 hour",
  "8 hour",
];

enum TimerEnum {
  infinite,
  q10qmins,
  q20qmins,
  q30qmins,
  q40qins,

  q1qhour,
  q2qhour,
  q4qhour,
  q8qhour,
}

timerEnumToString(String d) {
  switch (d) {
    case "infinite":
      return TimerEnum.infinite.toString();
    case "q10qmins":
      return TimerEnum.q10qmins.toString();
    case "q20qmins":
      return TimerEnum.q20qmins.toString();
    case "q30qmins":
      return TimerEnum.q30qmins.toString();
    case "q40qmins":
      return TimerEnum.q40qins.toString();
    case "q1qhour":
      return TimerEnum.q1qhour.toString();
    case "q2qhour":
      return TimerEnum.q2qhour.toString();
    case "q4qhour":
      return TimerEnum.q4qhour.toString();
    case "q8qhour":
      return TimerEnum.q8qhour.toString();
  }
}
