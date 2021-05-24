import Soundfont, { InstrumentName } from "soundfont-player";
import { useCallback, useEffect, useState } from "react";

export default function useInstrument() {
  const [player, setPlayer] = useState<any>();

  useEffect(async () => {
    const audioContext = new (window.AudioContext ||
      ((window as any).webkitAudioContext as typeof AudioContext))();
    const player = await Soundfont.instrument(audioContext, "tada", {
      soundfont: "Tabla",
      isSoundfontURL: () => false,
      nameToUrl: (name, sf, format) => {
        return "https://gleitz.github.io/midi-js-soundfonts/Tabla/synth_drum-mp3.js";
      },
    });

    setPlayer(player);

    return () => {
      setPlayer(undefined);
      player.stop();
      audioContext.close();
    };
  }, []);

  const play = useCallback(() => {
    player.schedule(0, [
      { time: 0, note: "C4" },
      { time: 0.5, note: "D4" },
      { time: 1, note: "E4" },
      { time: 1.5, note: "F4" },
      { time: 2, note: "G4" },
      { time: 2.5, note: "A5" },
      { time: 3, note: "B5" },
      /* { time: 0.2, note: "D4" }, */
      /* { time: 1, note: "E4" }, */
    ]);
  }, [player]);

  return { play };
}
