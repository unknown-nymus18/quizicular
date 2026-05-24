import { useNavigate } from "react-router-dom";
import { useState } from "react"; 
import AuthApi from "../../scripts/AuthApi";
import "../../styles/loginpage/LoginPage.css";
import CustomInput from "../ui/CustomInput";
import ErrorMessage from "../ui/ErrorMessage";
import AnimatedGrid from "../ui/AnimatedGrid";

function LoginPage() {
  const navigate = useNavigate();
  const [message, setMessage] = useState<string>("");
  const [isLoading, setIsLoading] = useState<boolean>(false);

  const loginUser = async () => {
    const email = document.getElementById("email") as HTMLInputElement;
    const password = document.getElementById("password") as HTMLInputElement;

    setMessage(""); // Clear previous errors
    setIsLoading(true);

    try {
      const response = await AuthApi.login(email.value, password.value);

      if (response) {
        console.log("Login successful:", response);
        navigate("/"); // Navigate directly after successful login
      }
    } catch (error: any) {
      console.error("Login failed:", error);
      setMessage(error.message || "Error logging in");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <main className="login-main">
      <section className="first-section">
        <form>
          <h1>Log Into Account</h1>

          {message ? (
            <ErrorMessage>{message}</ErrorMessage>
          ) : (
            <p className="subtitle" id="subtitle">
              Join Quizicular to create and take quizzes on any topic!
            </p>
          )}

          <fieldset>
            <label htmlFor="email">Email</label>
            <CustomInput
              type="email"
              id="email"
              name="email"
              placeholder="Enter email here"
            />
            <br />

            <label htmlFor="password">Password</label>
            <CustomInput
              type="password"
              id="password"
              name="password"
              placeholder="Enter Password Here"
            />
            <br />

            <button
              className="login-btn"
              onClick={loginUser}
              type="button"
              disabled={isLoading}
            >
              {isLoading ? "Logging in..." : "Login"}
            </button>
          </fieldset>
        </form>
      </section>
      <section className="second-section">
        <AnimatedGrid />
      </section>
    </main>
  );
}

export default LoginPage;

