import { Link, useNavigate } from "react-router-dom";
import "../../styles/register/RegisterPage.css";
import CustomInput from "../ui/CustomInput";
import AuthApi from "@/scripts/AuthApi";
import AnimatedGrid from "../ui/AnimatedGrid";

function RegisterPage() {
  const navigate = useNavigate();

  async function registerUser() {
    const first_name = document.getElementById(
      "first_name",
    ) as HTMLInputElement;
    const last_name = document.getElementById("last_name") as HTMLInputElement;
    const email = document.getElementById("email") as HTMLInputElement;
    const password = document.getElementById("password") as HTMLInputElement;
    const confirm_password = document.getElementById(
      "confirm-password",
    ) as HTMLInputElement;
    if (password.value != confirm_password.value) {
      return;
    }
    if (
      !first_name.value ||
      !last_name.value ||
      !email.value ||
      !password.value
    ) {
      return;
    }

    const response = await AuthApi.register(
      first_name.value,
      last_name.value,
      email.value,
      password.value,
      confirm_password.value,
    );
    if (response) {
      console.log("Registration successful:", response);
      navigate("/"); // Navigate directly after successful login
    }
  }
  return (
    <main className="register-main">
      <section className="first-section">
        <Link to={"/"}>
          <div className="home-btn">
            <p>{"<-"}</p>
          </div>
        </Link>
        <h1>Create An Account</h1>
        <p className="subtitle" id="subtitle">
          Join Quizicular to create and take quizzes on any topic!
        </p>
        <fieldset>
          <label>First Name</label>
          <CustomInput
            type="text"
            id="first_name"
            name="first_name"
            required
            placeholder="Enter First Name Here"
          />
          <br />

          <label>Last Name</label>
          <CustomInput
            type="text"
            id="last_name"
            name="last_name"
            required
            placeholder="Enter Last Name Here"
          />
          <br />

          <label>Email</label>
          <CustomInput
            type="email"
            id="email"
            name="email"
            required
            placeholder="Enter Email Here"
          />
          <br />

          <label>Password</label>
          <CustomInput
            id="password"
            name="password"
            placeholder="Enter Password Here"
            type="password"
          ></CustomInput>
          <br />

          <label>Confirm Password</label>
          <CustomInput
            type="password"
            id="confirm-password"
            name="confirm-password"
            required
            placeholder="Confirm Password"
          />
          <br />

          <button className="submit-btn" type="button" onClick={registerUser}>
            Create Account
          </button>
        </fieldset>
      </section>
      <section className="second-section">
        <AnimatedGrid />
      </section>
    </main>
  );
}

export default RegisterPage;

