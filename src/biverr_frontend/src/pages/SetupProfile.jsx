import React from 'react'
import TextInput from '../components/TextInput'
import Button from '../components/Button'
import { Select } from "antd";

const SetupProfile = () => {
  const [info, setInfo] = useState({
    name: '',
    role: ''
  })

  const onChange = (value) => {
    setInfo({
      ...info,
      role: value
    })
  }

  return (
    <div className='h-[70vh] w-full justify-center items-center flex flex-col space-y-5'>
      <span className='font-jakarta text-xl'>Setup Profile</span>
       <div className='h-fit border w-[20vw]  p-10 rounded-lg flex flex-col space-y-5 shadow-md bg-white justify-center items-center'>
          <TextInput type={"text"} label={"Name"} />
          <Select onChange={onChange} className='w-full outline-none' placeholder='Who are you?'>
            <Select.Option value="sample">Client</Select.Option>
            <Select.Option value="sample">Freelancer</Select.Option>
          </Select>
          <Button label={"Continue"} bgStyle={`bg-green-500`} textStyle={`text-white`}/>
        </div>
    </div>
  )
}

export default SetupProfile
