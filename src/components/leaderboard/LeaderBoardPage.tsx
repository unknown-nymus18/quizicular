import { useEffect, useState } from "react";
import NavBar from "../NavBar";
import AuthApi from "../../scripts/AuthApi";
import Winner from "./Winner";
import "../../styles/leaderboard.css";

interface User {
  id: number;
  username: string;
  email: string;
  first_name: string;
  last_name: string;
  is_authenticated: boolean;
  profile: {
    streak: number;
    quizzes_completed: number;
    total_score: number;
  };
}

interface LeaderBoard {
  first_name: string;
  last_name: string;
  quizzes_completed: number;
  streak: number;
  total_score: number;
  username: string;
}

function LeaderBoardPage() {
  const [user, setUser] = useState<User | null>(null);
  const [leaderBoard, setLeaderBoard] = useState<LeaderBoard[]>([]);
  // const [isLoading, setIsLoading] = useState(true);
  const sortedLeaderBoard = [...leaderBoard].sort(
    (a, b) => b.total_score - a.total_score,
  );
  const topScore = sortedLeaderBoard[0]?.total_score ?? 0;

  const checkAuthentication = async () => {
    // setIsLoading(true);
    try {
      const response = await AuthApi.checkAuth();
      const getLeaderBoard = await AuthApi.getLeaderBoard();
      if (getLeaderBoard) {
        console.log(getLeaderBoard);
        const leaderBoardData = Array.isArray(getLeaderBoard)
          ? getLeaderBoard
          : (getLeaderBoard?.leaderboard ?? []);
        setLeaderBoard(leaderBoardData);
      } else {
        setLeaderBoard([]);
      }
      if (response) {
        setUser(response);
        // console.log(response);
      } else {
        setUser(null);
      }
    } catch (error) {
      setUser(null);
    } finally {
      // setIsLoading(false);
    }
  };

  useEffect(() => {
    checkAuthentication();
  }, []);

  return (
    <>
      <NavBar user={user}></NavBar>
      <div style={{ height: 200 }}></div>
      <div className="leaderboard-shell">
        <div className="leaderboard-podium">
          {sortedLeaderBoard[1] && (
            <Winner position={2} leaderBoard={sortedLeaderBoard[1]}></Winner>
          )}
          {sortedLeaderBoard[0] && (
            <Winner position={1} leaderBoard={sortedLeaderBoard[0]}></Winner>
          )}
          {sortedLeaderBoard[2] && (
            <Winner position={3} leaderBoard={sortedLeaderBoard[2]}></Winner>
          )}
        </div>
        <div className="leaderboard-list">
          <div className="leaderboard-list-header">
            <div>Place</div>
            <div className="leaderboard-list-header-user">User</div>
            <div className="leaderboard-list-header-points">Points</div>
          </div>
          {sortedLeaderBoard.slice(3).map((player, index) => {
            const rank = index + 4;
            const ratio = topScore ? player.total_score / topScore : 0;
            const width = `${Math.min(Math.max(ratio, 0.12), 1) * 100}%`;
            const initials =
              `${player.first_name?.[0] ?? ""}${player.last_name?.[0] ?? ""}`.toUpperCase();

            return (
              <div className="leaderboard-row" key={player.username}>
                <div className="leaderboard-row-rank">{rank}</div>
                <div className="leaderboard-row-avatar">
                  <span>{initials || "?"}</span>
                </div>
                <div className="leaderboard-row-info">
                  <div className="leaderboard-row-name">
                    {player.first_name} {player.last_name}
                  </div>
                  <div className="leaderboard-row-handle">
                    @{player.username}
                  </div>
                </div>
                <div className="leaderboard-row-score">
                  <div className="leaderboard-row-points">
                    {player.total_score} pts
                  </div>
                  <div className="leaderboard-row-meter">
                    <span style={{ width }}></span>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </>
  );
}

export default LeaderBoardPage;
