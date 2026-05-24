class AuthApi {
  static baseUrl = (import.meta.env.VITE_API_BASE_URL || (import.meta.env.DEV ? "" : "https://quizicular.onrender.com")) + "/api/account";

  static checkAuth() {
    return fetch(`${this.baseUrl}/is_authenticated/`, {
      method: "GET",
      headers: { "Content-Type": "application/json" },
      credentials: "include",
    }).then((response) => this.handleResponse(response));
  }

  static login(email: String, password: String) {
    return fetch(`${this.baseUrl}/login/`, {
      method: "POST",
      body: JSON.stringify({ email, password }),
      headers: { "Content-Type": "application/json" },
      credentials: "include",
    }).then((response) => this.handleResponse(response));
  }

  static logout() {
    return fetch(`${this.baseUrl}/logout/`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      credentials: "include",
    }).then((response) => this.handleResponse(response));
  }

  static register(
    first_name: String,
    last_name: String,
    email: String,
    password: String,
    confirm_password: String,
  ) {
    return fetch(`${this.baseUrl}/register/`, {
      method: "POST",
      body: JSON.stringify({
        first_name,
        last_name,
        email,
        password,
        confirm_password,
      }),
      headers: { "Content-Type": "application/json" },
      credentials: "include",
    }).then((response) => this.handleResponse(response));
  }

  static getLeaderBoard() {
    return fetch(`${this.baseUrl}/leaderboard/`, {
      method: "GET",
      headers: { "Content-Type": "application/json" },
      credentials: "include",
    }).then((response) => this.handleResponse(response));
  }

  static handleResponse(response: Response) {
    if (response.ok) {
      return response.json();
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

export default AuthApi;
