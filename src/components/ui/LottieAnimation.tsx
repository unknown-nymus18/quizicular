import Lottie from "lottie-react";
import { useCallback, useRef } from "react";
import type { LottieRefCurrentProps } from "lottie-react";

interface LottieAnimationProps {
  animationData: any;
  width?: number;
  height?: number;
  loop?: boolean;
  autoplay?: boolean;
  className?: string;
  onAnimationComplete?: () => void;
  onClick?: () => void;
  playOnClick?: boolean;
}

function LottieAnimation({
  animationData,
  width = 200,
  height = 200,
  loop = true,
  autoplay = true,
  className = "",
  onAnimationComplete,
  onClick,
  playOnClick = false,
}: LottieAnimationProps) {
  const lottieRef = useRef<LottieRefCurrentProps | null>(null);

  const handleClick = useCallback(() => {
    onClick?.();

    if (!playOnClick) return;

    lottieRef.current?.stop();
    lottieRef.current?.goToAndPlay(0, true);
  }, [onClick, playOnClick]);

  const isInteractive = playOnClick || Boolean(onClick);

  return (
    <div
      className={`lottie-container ${className}`}
      onClick={isInteractive ? handleClick : undefined}
      role={isInteractive ? "button" : undefined}
      tabIndex={isInteractive ? 0 : undefined}
      onKeyDown={
        isInteractive
          ? (e) => {
              if (e.key === "Enter" || e.key === " ") {
                e.preventDefault();
                handleClick();
              }
            }
          : undefined
      }
      style={isInteractive ? { cursor: "pointer" } : undefined}
    >
      <Lottie
        animationData={animationData}
        style={{ width, height }}
        loop={loop}
        autoplay={autoplay}
        lottieRef={lottieRef}
        onComplete={onAnimationComplete}
      />
    </div>
  );
}

export default LottieAnimation;
