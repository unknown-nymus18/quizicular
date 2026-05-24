import { Link } from "react-router-dom";
import "../styles/NavBar.css";
import CustomButton from "./ui/CustomButton";
import AuthApi from "../scripts/AuthApi";

interface User {
  id: number;
  username: string;
  email: string;
  first_name: string;
  last_name: string;
  is_authenticated: boolean;
}

interface Props {
  user?: User | null;
  onUserChange?: () => void;
}

function NavBar({ user, onUserChange }: Props) {
  const handleLogout = async () => {
    try {
      await AuthApi.logout();
      if (onUserChange) {
        onUserChange();
      }
    } catch (error) {
      console.error("Logout failed:", error);
    }
  };

  return (
    <nav>
      <div className="home-user">
        <Link to={"/"}>
          <h3>Quizicular</h3>
        </Link>
        <h2>|</h2>
        <Link to={"/profile"} id="user">
          <h3>
            {user?.is_authenticated
              ? `${user.first_name} ${user.last_name}`
              : "Guest"}
          </h3>
        </Link>
      </div>
      <Link to={"/leaderboard"}>Leader Board</Link>

      <div className="auths">
        {user?.is_authenticated ? (
          <CustomButton onClick={handleLogout} color="secondary">
            Logout
          </CustomButton>
        ) : (
          <>
            <Link to={"/login"}>
              <CustomButton onClick={() => {}} color="secondary">
                Login
              </CustomButton>
            </Link>
            <Link to={"/register"}>
              <CustomButton onClick={() => {}}>Register</CustomButton>
            </Link>
          </>
        )}
      </div>
    </nav>
  );
}

export default NavBar;
