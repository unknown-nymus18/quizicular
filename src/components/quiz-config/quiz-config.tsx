import { useState } from "react";
import "../../styles/quiz-config/quiz-config.css";
import { useNavigate } from "react-router-dom";
import ErrorMessage from "../ui/ErrorMessage";

function QuizConfig() {
  const [topic, setTopic] = useState<boolean>(true);
  const [errorMessage, setErrorMessages] = useState<String>("");
  const navigate = useNavigate();

  function changeInput() {
    setTopic(!topic);
  }

  function generateQuiz() {
    const topic = (document.getElementById("topic-input") as HTMLInputElement)
      ?.value;
    const difficulty = (
      document.getElementById("difficulty-select") as HTMLSelectElement
    )?.value;
    const questionsNumber = (
      document.getElementById("questions-select") as HTMLSelectElement
    )?.value;
    if (!topic || !difficulty || !questionsNumber) {
      setErrorMessages((e) => "Fill in the info");
    } else {
      navigate(
        `/quiz/${difficulty}/${questionsNumber}?topic=${encodeURIComponent(topic)}`,
      );
    }
  }

  return (
    <div className="quiz-config">
      <div className="show-messages">
        {errorMessage && <ErrorMessage>{errorMessage}</ErrorMessage>}
      </div>
      <div className="container">
        <h1>Create Your Quiz</h1>
        <p className="subtitle">
          Generate custom quizzes from any topic or document
        </p>

        <div className="slider-button" onClick={changeInput}>
          <p className={topic ? "selected" : ""} id="topic">
            Topic
          </p>
          <p id="file" className={!topic ? "selected" : ""}>
            Upload File
          </p>
        </div>

        <div className="quiz-input">
          {topic ? (
            <>
              <p>Enter a topic</p>
              <input
                type="text"
                placeholder="e.g., World War II, Python Programming, Renaissance Art"
                id="topic-input"
              ></input>
              <span>Enter any topic you'd like to be quizzed on</span>
            </>
          ) : (
            <>
              <p>Upload a document</p>
              <p>Feature is yet to be rolled out</p>
            </>
          )}
        </div>
        <div className="quiz-level">
          <select id="difficulty-select">
            <option value="easy">Easy</option>
            <option value="medium">Medium</option>
            <option value="hard">Hard</option>
          </select>
        </div>

        <div className="questions-number">
          <select id="questions-select">
            <option value="5">5 Questions</option>
            <option value="10">10 Questions</option>
            <option value="15">15 Questions</option>
            <option value="20">20 Questions</option>
          </select>
        </div>

        <button id="generate-quiz" onClick={generateQuiz}>
          Generate Quiz
        </button>
      </div>
    </div>
  );
}

export default QuizConfig;
