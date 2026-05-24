import Subtitle from "../Subtitile";
import "../../styles/homepage/FeaturesSection.css";

function FeaturesSection() {
  return (
    <div className="features-section">
      <h1>Everything you need to excel</h1>
      <Subtitle>
        Powerful features designed to make learning engaging and effective
      </Subtitle>
      <div className="features">
        <div className="feature">
          <h2>AI-Powered Quiz Generation</h2>
          <p>
            Simply enter a topic, and our AI creates relevant quiz questions
            instantly.
          </p>
        </div>
        <div className="feature">
          <h2>Multiple Topics</h2>
          <p>
            Create quizzes on any subject - from science and history to
            programming and literature.
          </p>
        </div>
        <div className="feature">
          <h2>Track Progress</h2>
          <p>
            Monitor your scores and see detailed results with performance
            analytics after each quiz.
          </p>
        </div>
      </div>
    </div>
  );
}

export default FeaturesSection;
