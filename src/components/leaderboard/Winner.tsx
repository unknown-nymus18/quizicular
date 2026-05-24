import "../../styles/leaderboard.css";

interface Props {
  position: number;
  leaderBoard: LeaderBoard;
}

interface LeaderBoard {
  first_name: string;
  last_name: string;
  quizzes_completed: number;
  streak: number;
  total_score: number;
  username: string;
}

function Winner({ position, leaderBoard }: Props) {
  const ordinal =
    position === 1
      ? "1st"
      : position === 2
        ? "2nd"
        : position === 3
          ? "3rd"
          : `${position}th`;
  const initials = `${leaderBoard.first_name?.[0] ?? ""}${
    leaderBoard.last_name?.[0] ?? ""
  }`.toUpperCase();

  return (
    <div className={`winner winner-${position}`} data-position={position}>
      <div className="winner-header">
        <div className="winner-avatar" aria-hidden="true">
          <div className="winner-avatar-inner">
            <span>{initials || "?"}</span>
          </div>
          <div className="winner-rank">{ordinal}</div>
        </div>
        <div className="winner-details">
          <div className="winner-name">
            {leaderBoard.first_name} {leaderBoard.last_name}
          </div>
          <div className="winner-score">
            <span className="winner-score-dot" aria-hidden="true"></span>
            {leaderBoard.total_score} pts
          </div>
        </div>
      </div>
      <div className="scene">
        <div className="cube">
          <div className="face front">
            <span className="podium-label">{ordinal}</span>
          </div>
          <div className="face top"></div>
        </div>
      </div>
    </div>
  );
}

export default Winner;
