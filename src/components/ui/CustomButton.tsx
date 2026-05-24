import { ReactNode } from "react";
import "../../styles/ui/CustomButton.css";
interface Props {
  children: ReactNode;
  color?: "primary" | "secondary" | "black";
  onClick?: () => void;
  id?: any;
}

function CustomButton({ color = "primary", children, onClick, id }: Props) {
  return (
    <button className={`btn btn-${color}`} onClick={onClick} id={id}>
      {children}{" "}
    </button>
  );
}

export default CustomButton;
