import React, { useState } from 'react'
import Button from './Button'
import { DatePicker, Modal } from 'antd';
import TextInput from './TextInput';
import TextArea from 'antd/es/input/TextArea';

const Sidebar = () => {
  const [selected, setSelected] = useState('discover')
  const [createTaskModal, setCreateTaskModal] = useState(false);
    const [confirmLoading, setConfirmLoading] = useState(false);

    const onChange = (date, dateString) => {
      console.log(date, dateString);
    };

    const showTaskCreationModal = () => {
        setCreateTaskModal(true)
    }

    const handleTaskCreation = () => {
        setCreateTaskModal(false);
      };
  
    const handleTaskCreationCancel = () => {
        setCreateTaskModal(false)
    }


  return (
    <><div className='border-r w-[20vw] p-10 flex flex-col justify-between h-screen sticky top-0'>
      <div className='w-full flex flex-col items-center space-y-10'>
        <span className='font-lobster text-4xl font-semibold text-green-500'>Biverr</span>
        <div className='flex flex-col space-y-8 items-start w-full'>
          <button onClick={() => setSelected('discover')} className={`p-5 font-semibold rounded-lg w-full ${selected === 'discover' && "bg-green-600 text-white font-semibold"}`}>Discover</button>
          <button onClick={() => setSelected('bids')} className={`p-5 font-medium rounded-lg w-full ${selected === 'bids' && "bg-green-600 text-white font-semibold"}`}>Bids</button>
          <button onClick={() => setSelected('tasks')} className={` p-5 font-semibold rounded-lg w-full ${selected === 'tasks' && "bg-green-600 text-white font-semibold"}`}>Tasks</button>
      </div>
    </div><div className='w-full flex flex-col justify-center items-center space-y-4'>
        <span className='font-jakarta font-semibold'>Balance: 50 ICP</span>
          <button onClick={showTaskCreationModal} className={` p-2 px-4 text-green-500 border-gray-400 font-jakarta font-semibold rounded-lg border ${selected === 'create' && "bg-green-600 text-white font-semibold"}`}>Create Task</button>
        <Button label={"Logout"} textStyle={"text-green-500 font-semibold"} bgStyle={"border-green-500"} />
      </div><Modal
        title="Create Task"
        open={createTaskModal}
        onOk={handleTaskCreation}
        confirmLoading={confirmLoading}
        onCancel={handleTaskCreationCancel}
      >
        <div className='flex flex-col space-y-4'>
          <TextInput label={"Title"} />
          <TextArea placeholder='Description...' />
          <TextInput label={"Budget"} type={"number"} />
          <TextInput label={"Set Minimum bid"} type={"number"} />
          <DatePicker onChange={onChange} />
        </div>

      </Modal>
    </div>
    </>
  )
}

export default Sidebar
