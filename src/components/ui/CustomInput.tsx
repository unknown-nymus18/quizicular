import "../../styles/ui/CustomInput.css";

interface Props {
  type?: "number" | "text" | "email" | "password";
  placeholder?: any;
  id: any;
  name: any;
  required?: boolean;
}

function CustomInput({
  type = "text",
  placeholder,
  id,
  name,
  required,
}: Props) {
  return (
    <input
      className="custom-input"
      id={id}
      type={type}
      name={name}
      placeholder={placeholder}
      required={required}
    ></input>
  );
}

export default CustomInput;
