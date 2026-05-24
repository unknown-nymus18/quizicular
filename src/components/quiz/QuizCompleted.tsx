import { useNavigate } from "react-router-dom";
import successAnimation from "../../assets/animations/Success.json";
import CustomButton from "../ui/CustomButton";
import LottieAnimation from "../ui/LottieAnimation";
import { useEffect } from "react";
import AuthApi from "../../scripts/AuthApi";
import QuizApi from "../../scripts/QuizApi";

interface Props {
  totalNumber: number;
  correct: number;
}

function QuizCompleted({ totalNumber, correct }: Props) {
  const navigate = useNavigate();
  useEffect(() => {
    const response = QuizApi.updatePoints((correct / totalNumber) * 100);
    response.then((reponse) => {
      console.log(response);
    });
  }, []);
  return (
    <div className="quiz-completed">
      <div className="quiz-completed-hero">
        <LottieAnimation
          animationData={successAnimation}
          loop={false}
          playOnClick={true}
        ></LottieAnimation>
      </div>
      <h1 className="quiz-completed-title">Quiz completed</h1>
      <p className="quiz-completed-score">
        Score: {correct} / {totalNumber}
      </p>
      <p className="quiz-completed-caption">
        Review your answers and try again to improve your score.
      </p>
      <button
        onClick={() => {
          navigate("/");
        }}
      >
        Go Home
      </button>
    </div>
  );
}

export default QuizCompleted;
