class QuizApi {
  static baseUrl = (import.meta.env.VITE_API_BASE_URL || "") + "/api/quiz/";

  static getQuiz(topic: String, difficulty: String, questions_number: number) {
    return fetch(`${this.baseUrl}`, {
      method: "POST",
      body: JSON.stringify({ topic, difficulty, questions_number }),
      headers: { "Content-Type": "application/json" },
      credentials: "include",
    }).then((response) => this.handleResponse(response));
  }

  static addQuizAttemp(request_data: JSON) {
    return fetch(`${this.baseUrl}attempts/`, {
      method: "POST",
      body: JSON.stringify(request_data),
      headers: { "Content-Type": "application/json" },
      credentials: "include",
    }).then((response) => this.handleResponse(response));
  }

  static getUserQuizzes() {
    return fetch(`${this.baseUrl}attempts/list/`, {
      method: "GET",
      headers: { "Content-Type": "application/json" },
      credentials: "include",
    }).then((response) => this.handleResponse(response));
  }

  static updatePoints(points: number) {
    return fetch(`${this.baseUrl}update-points/`, {
      method: "POST",
      body: JSON.stringify({ points }),
      headers: { "Content-Type": "application/json" },
      credentials: "include",
    }).then((response) => this.handleResponse(response));
  }

  static handleResponse<T = any>(response: Response): Promise<T> {
    if (response.ok) {
      return response.json() as Promise<T>;
    } else {
      // Throw error with status code for better error handling
      let errorMessage = "Login failed";

      switch (response.status) {
        case 400:
          errorMessage = "Invalid request. Please check your input.";
          break;
        case 401:
          errorMessage = "Invalid email or password. Please try again.";
          break;
        case 403:
          errorMessage = "Access denied.";
          break;
        case 404:
          errorMessage = "Service not found. Please contact support.";
          break;
        case 500:
          errorMessage = "Server error. Please try again later.";
          break;
        default:
          errorMessage = `Request failed (${response.status}). Please try again.`;
      }

      throw new Error(errorMessage);
    }
  }
}

export default QuizApi;
