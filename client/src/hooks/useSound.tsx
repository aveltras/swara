import Soundfont, { InstrumentName } from "soundfont-player";
import { useCallback, useEffect, useState } from "react";

export default function useInstrument() {
  const [player, setPlayer] = useState<any>();

  useEffect(async () => {
    const audioContext = new (window.AudioContext ||
      ((window as any).webkitAudioContext as typeof AudioContext))();
    const player = await Soundfont.instrument(audioContext, "sitar", {
      soundfont: "FluidR3_GM",
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
      { time: 0, note: "C3" },
      { time: 0.5, note: "D3" },
      { time: 1, note: "E3" },
      { time: 1.5, note: "F3" },
      { time: 2, note: "G3" },
      { time: 2.5, note: "A4" },
      { time: 3, note: "B4" },
      /* { time: 0.2, note: "D4" }, */
      /* { time: 1, note: "E4" }, */
    ]);
  }, [player]);

  return { play };
}
