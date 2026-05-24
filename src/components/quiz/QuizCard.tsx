import { useEffect, useState } from "react";
import "../../styles/quiz/quiz-card.css";
interface Props {
  questionNumber: number;
  question: String;
  choices: String[];
  answer: number;
  total: number;
  onChoiceSelect: (selectedIndex: number) => void;
}
function QuizCard({
  questionNumber,
  question,
  choices,
  answer,
  total,
  onChoiceSelect,
}: Props) {
  const [selectedChoice, setSelectedChoice] = useState<number | null>(null);
  const [isAnswered, setIsAnswered] = useState(false);

  // Reset state when question changes
  useEffect(() => {
    setSelectedChoice(null);
    setIsAnswered(false);
  }, [questionNumber]);

  function selectChoice(index: number) {
    if (isAnswered) return; // Prevent multiple selections

    setSelectedChoice(index);
    setIsAnswered(true);
    onChoiceSelect(index); // Pass the selected index to parent
  }

  function getChoiceClassName(index: number) {
    let className = "option-btn";

    if (isAnswered && selectedChoice === index) {
      className += index === answer ? " correct" : " incorrect";
    }

    return className;
  }
  return (
    <div className="quiz-card">
      <p className="question-number-badge">
        Question {questionNumber} out of {total}
      </p>
      <h1>{question}</h1>
      <div className="options-container">
        {choices.map((choice, index) => (
          <p
            className={getChoiceClassName(index)}
            data-index={index}
            key={index}
            onClick={() => selectChoice(index)}
            style={{ cursor: isAnswered ? "default" : "pointer" }}
          >
            {choices[index]}
          </p>
        ))}
      </div>
    </div>
  );
}

export default QuizCard;

{
  /* <div class="quiz-card">
        <p class="question-number-badge">Question ${currentQuestionIndex+1} out of ${quiz_data.ai_generated_quiz.length}</p>
        <h1>${quiz_data.ai_generated_quiz[currentQuestionIndex].question}</h1>
        <div class="options-container">${choices}</div>
    </div> */
}
