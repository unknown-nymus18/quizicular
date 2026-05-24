import { Link } from "react-router-dom";
import "../../styles/homepage/hero.css";
import LottieAnimation from "../ui/LottieAnimation";
import StudentAnimation from "../../assets/animations/STUDENT.json";

interface User {
  is_authenticated: boolean;
  profile: {
    streak: number;
    quizzes_completed: number;
    total_score: number;
  };
}
interface Props {
  user?: User | null;
  onUserChange: () => void;
}
function Hero({ user }: Props) {
  return (
    <div className="hero">
      <div className="divide-section">
        <div>
          <p className="streak">
            {user?.is_authenticated ? `${user?.profile.streak}` : "0"}🔥day
            Streaks
          </p>
          <p id="ai-quizzes">AI generated Quizzes</p>
          <div>
            <h1>
              Master the art of <br />
              Multiple choice questions
            </h1>
            <p className="subtitle">
              Generate custom quizzes from any topic. Test your knowledge, track
              your progress, and learn faster with Quizicular.
            </p>
          </div>
        </div>
        <LottieAnimation
          animationData={StudentAnimation}
          width={500}
          height={400}
        ></LottieAnimation>
      </div>
      <div className="button-container">
        <a href="/pages/login.html">
          <button className="get-started-btn">Get Started</button>
        </a>

        <Link to={"/quiz-config"}>
          <button id="generate-quiz-btn">Generate quiz</button>
        </Link>
      </div>
      <div className="sub-info">
        <p> &bull;No credit card required</p>
        <p> &bull;AI powered quiz generation</p>
      </div>
    </div>
  );
}

export default Hero;
