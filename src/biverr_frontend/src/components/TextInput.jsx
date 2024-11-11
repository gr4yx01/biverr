import React from 'react'

const TextInput = ({ label, type, onChange }) => {
  return (
    <div className='w-full'>
      <input onChange={onChange} type={type} placeholder={label} className='w-full border p-3 rounded-lg outline-none font-jakarta'/>
    </div>
  )
}

export default TextInput
