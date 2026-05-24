import NavBar from "../NavBar";
import "../../styles/profile.css";
import { useEffect, useState } from "react";
import AuthApi from "../../scripts/AuthApi";
import LottieAnimation from "../ui/LottieAnimation";
import profileAnimation from "../../assets/animations/new_man_1.json";
import streakAnimation from "../../assets/animations/streak-animation.json";
import QuizApi from "../../scripts/QuizApi";
import QuizTable from "./QuizTable";

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

interface Quiz_data {
  answer_index: Number;
  chosen_answer: Number;
  options: String[];
  question: String;
}

interface Quizzes {
  completed_at: Date;
  correct_answers: Number;
  difficulty: String;
  quiz_data: Quiz_data[];
  score_percentage: Number;
  time_taken: String;
  topic: String;
  total_questions: Number;
}

function Profile() {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [quizzes, setQuizzes] = useState<any[] | null>(null);

  const checkAuthentication = async () => {
    setIsLoading(true);
    try {
      const response = await AuthApi.checkAuth();
      const allQuiz: any = await QuizApi.getUserQuizzes();
      if (Array.isArray(allQuiz)) setQuizzes(allQuiz);
      if (response) {
        setUser(response); // AuthApi.checkAuth() returns user directly or null
      } else {
        setUser(null);
      }
    } catch (error) {
      setUser(null);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    checkAuthentication();
  }, []);

  const displayName = user?.is_authenticated
    ? `${user.first_name} ${user.last_name}`
    : "Guest";

  return (
    <div className="profile">
      <NavBar user={user} onUserChange={checkAuthentication}></NavBar>
      <div style={{ height: 80 }}></div>

      <main className="profile-main">
        <section className="profile-hero">
          <div className="profile-hero-avatar">
            <LottieAnimation
              animationData={profileAnimation}
              playOnClick={true}
              autoplay={true}
              loop={false}
              height={190}
              width={190}
            ></LottieAnimation>
          </div>

          <div className="profile-hero-body">
            <h2 className="profile-name">{displayName}</h2>
            <p className="profile-subtitle">Bonus Booster, 24 lv</p>

            {/* <div className="profile-progress">
              <div className="profile-progress-labels">
                <span>
                  {isLoading ? "..." : `${progressValue} / ${progressMax} XP`}
                </span>
              </div>
              <div className="profile-progress-track">
                <div
                  className="profile-progress-fill"
                  style={{ width: `${isLoading ? 10 : progressPct}%` }}
                />
              </div>
            </div> */}

            <div className="profile-stats">
              <div className="profile-stat">
                <div className="profile-stat-icon">
                  <LottieAnimation
                    animationData={streakAnimation}
                    height={30}
                    width={30}
                    loop={false}
                    playOnClick={true}
                  ></LottieAnimation>
                </div>
                <div className="profile-stat-value">{user?.profile.streak}</div>
                <div className="profile-stat-label">Quiz Streak(s)</div>
              </div>
              <div className="profile-stat">
                <div className="profile-stat-icon" />
                <div>
                  <div className="profile-stat-value">
                    {user?.profile.total_score}
                  </div>
                  <div className="profile-stat-label">Total Score</div>
                </div>
              </div>
              <div className="profile-stat">
                <div className="profile-stat-icon" />
                <div>
                  <div className="profile-stat-value">
                    {user?.profile.quizzes_completed}
                  </div>
                  <div className="profile-stat-label">Quizzes Completed</div>
                </div>
              </div>
            </div>
          </div>
        </section>
        <section className="user-quizzes">
          <QuizTable quizzes={quizzes}></QuizTable>
        </section>
      </main>
    </div>
  );
}

export default Profile;
