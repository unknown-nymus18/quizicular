import { ReactNode } from "react";
import "../../styles/ui/ErrorMessage.css";

interface Props {
  children: ReactNode;
}
function ErrorMessage({ children }: Props) {
  return (
    <div className="error-container">
      <p className="error-message">{children}</p>
    </div>
  );
}

export default ErrorMessage;
