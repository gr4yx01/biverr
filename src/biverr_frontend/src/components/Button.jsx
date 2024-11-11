import React from 'react'

const Button = ({ label, bgStyle, textStyle, handlePress }) => {
  return (
    <button onClick={handlePress} className={`${bgStyle} flex justify-center items-center border p-3 px-8 rounded-lg`}>
        <span className={`${textStyle} font-jakarta font-semibold`}>
            {label}
        </span>
    </button>
  )
}

export default Button
