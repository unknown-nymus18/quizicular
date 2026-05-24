interface Props {
  quizzes?: any[] | null;
}

function QuizTable({ quizzes }: Props) {
  const formatCompletedAt = (completedAt: any) => {
    const date =
      completedAt instanceof Date ? completedAt : new Date(completedAt);
    return Number.isNaN(date.getTime()) ? "-" : date.toLocaleDateString();
  };

  const rows = quizzes ?? [];

  return (
    <div className="quiz-table-card">
      <div className="quiz-table-title">Your quizzes</div>
      <div className="quiz-table-scroll">
        <table className="quiz-table">
          <thead>
            <tr>
              <th>Topic</th>
              <th>Difficulty</th>
              <th>Date Completed</th>
              <th className="quiz-table-score">Score</th>
            </tr>
          </thead>
          <tbody>
            {rows.length === 0 ? (
              <tr>
                <td className="quiz-table-empty" colSpan={4}>
                  No quizzes yet.
                </td>
              </tr>
            ) : (
              rows.map((quiz, index) => (
                <tr key={`${quiz?.topic ?? "quiz"}-${index}`}>
                  <td>{quiz?.topic ?? "-"}</td>
                  <td>{quiz?.difficulty ?? "-"}</td>
                  <td>{formatCompletedAt(quiz?.completed_at)}</td>
                  <td className="quiz-table-score">
                    {typeof quiz?.score_percentage === "number"
                      ? `${quiz.score_percentage}%`
                      : (quiz?.score_percentage ?? "-")}
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default QuizTable;
