class HMSAudioShare {
  final String url;
  final bool loop;
  final bool interrupts;

  HMSAudioShare(
      {required this.url, this.loop = false, this.interrupts = false});

  Map<String, dynamic> toMap() {
    return {"url": url, "loop": loop, "interrupts": interrupts};
  }
}
