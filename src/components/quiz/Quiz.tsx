import Lottie from "lottie-react";
import { useParams, useSearchParams } from "react-router-dom";
import LottieAnimation from "../ui/LottieAnimation";
import loadingAnimation from "../../assets/animations/ai-loading-screen.json";
import "../../styles/quiz/quiz.css";
import { useEffect, useState } from "react";
import QuizApi from "../../scripts/QuizApi";
import QuizCard from "./QuizCard";
import QuizCompleted from "./QuizCompleted";

interface QuestionData {
  question: string;
  choices: string[];
  answer_index: number;
  chosen_answer?: number;
}
interface QuizData {
  status: string;
  difficulty: string;
  ai_generated_quiz: QuestionData[];
  topic: string;
  success: string;
}
function Quiz() {
  const { difficulty, questionsNumber } = useParams();
  const [searchParams] = useSearchParams();
  const topic = searchParams.get("topic");

  const [quizData, setQuizData] = useState<QuizData | null>();
  const [userAnswers, setUserAnswers] = useState<number[]>([]);
  const [loading, setLoading] = useState(true);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [quizCompleted, setQuizCompleted] = useState(false);

  useEffect(() => {
    async function fetchQuiz() {
      try {
        setLoading(true);
        const response = await QuizApi.getQuiz(
          topic!,
          difficulty!,
          Number.parseInt(questionsNumber!),
        );
        setQuizData(response);
        // Initialize user answers array
        setUserAnswers(new Array(response.ai_generated_quiz.length).fill(-1));
      } catch (error) {
        console.error("Error fetching quiz:", error);
      } finally {
        setLoading(false);
      }
    }

    fetchQuiz();
  }, []);

  // Callback to receive data from QuizCard
  function onChoiceSelect(selectedChoiceIndex: number) {
    if (!quizData || !quizData.ai_generated_quiz[currentIndex]) return;
    // Update user answers
    setUserAnswers((prev) => {
      const newAnswers = [...prev];
      newAnswers[currentIndex] = selectedChoiceIndex;
      return newAnswers;
    });

    // Save chosen_answer index in quizData
    setQuizData((prevData) => {
      if (!prevData) return prevData;

      const updatedQuiz = [...prevData.ai_generated_quiz];
      updatedQuiz[currentIndex] = {
        ...updatedQuiz[currentIndex],
        chosen_answer: selectedChoiceIndex,
      };

      const updatedData = {
        ...prevData,
        ai_generated_quiz: updatedQuiz,
      };

      return updatedData;
    });

    const isLastQuestion = currentIndex === quizItems.length - 1;

    setTimeout(() => {
      if (isLastQuestion) {
        setQuizCompleted(true);
        return;
      }
      setCurrentIndex((c) => c + 1);
    }, 2000);
  }

  const quizItems = quizData?.ai_generated_quiz ?? [];
  const currentQuestion = quizItems[currentIndex];
  const totalQuestions = quizItems.length;
  const correctCount = quizData
    ? quizItems.filter((q) => q.chosen_answer === q.answer_index).length
    : 0;

  return (
    <>
      <div className="quiz-container">
        {loading || !quizData ? (
          <LottieAnimation
            className="loading-overlay"
            animationData={loadingAnimation}
            width={500}
            height={500}
          ></LottieAnimation>
        ) : quizCompleted ? (
          <QuizCompleted totalNumber={totalQuestions} correct={correctCount} />
        ) : !currentQuestion ? (
          <div className="quiz-empty">No questions available.</div>
        ) : (
          <div className="card-stack">
            <QuizCard
              questionNumber={currentIndex + 1}
              total={quizItems.length}
              choices={currentQuestion.choices}
              question={currentQuestion.question}
              answer={currentQuestion.answer_index}
              onChoiceSelect={onChoiceSelect}
            ></QuizCard>
          </div>
        )}
      </div>
    </>
  );
}

export default Quiz;
