import React from 'react'
import { Divider, Steps } from "antd";
import TextInput from '../components/TextInput';
import Button from '../components/Button';

const task = {
    title: 'Pentesting',
    description: 'You are to test the security of this website and provide a report',
    budget: 100,
    created_at: '14th March, 2024',
    deadline: '21st July, 2024',
    bid_amount_min: 50,
    selectedfreelancer: '384393249xduuf34'
};

const TaskDetail = () => {
  return (
    <div className='space-y-10'>
    <div className='flex items-center gap-20'>
      <div className=' font-jakarta flex flex-col space-y-5'>
        <span className='text-3xl font-semibold'>{task?.title}</span>
      <div className='flex flex-col space-y-2'>
          <span className='text-lg font-semibold'>Description: </span>    
          <span className='text-sm'>{task.description}</span>
      </div>
      <div className='flex flex-col space-y-2'>
          <span className='text-lg font-semibold'>Created: </span>    
          <span className='text-sm'>{task.created_at}</span>
      </div>
      <div className='flex flex-col space-y-2'>
          <span className='text-lg font-semibold'>Deadline: </span>    
          <span className='text-sm'>{task.deadline}</span>
      </div>
      <div className='flex flex-col space-y-2'>
          <span className='text-lg font-semibold'>Freelancer assigned: </span>    
          <span className='text-sm'>{task.selectedfreelancer}</span>
      </div>
    </div>
    <div>
      <span className='text-lg font-semibold'>Status: </span>    
      <Steps
        progressDot
        current={1}
        direction="vertical"
        items={[
          {
            title: 'Open',
            description: 'This is a description. This is a description.',
          },
          {
            title: 'Assigned',
            description: 'This is a description. This is a description.',
          },
          {
            title: 'In Progress',
            description: 'This is a description. This is a description.',
          },
          {
            title: 'Submitted',
            description: 'This is a description.',
          },
          {
            title: 'Approved',
            description: 'This is a description.',
          },
        ]}
      />
    </div>

    </div>
    <div className='gap-3 flex flex-col'>
      <span>Submission: </span>
      <TextInput label={"Enter link"}/>
      <Button bgStyle={"w-32 p-2"} label={"Submit"}/>
    </div>
    <div className='flex justify-between'>
      <div className='flex gap-4'>
        <Button label={"Approve"} bgStyle={"bg-green-500 text-white"}/>
        <Button label={"Reject"} bgStyle={"bg-red-500 text-white"} />
      </div>
        <Button label={"Close Task"} bgStyle={"bg-gray-500 text-white"} />
    </div>
</div>
  )
}

export default TaskDetail
