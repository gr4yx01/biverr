import React from 'react'
import { Link } from 'react-router-dom'
import Button from '../components/Button'

const tasks = [
    {
        title: 'Website Development',
        description: 'You are to build a website using HTML, CSS and JS',
        budget: 100,
        created_at: '14th July, 2024',
        deadline: '21st July, 2024',
        bid_amount_min: 50,
    },
    {
        title: 'Application Development',
        description: 'You are to build a mobile application using React Native',
        budget: 50,
        created_at: '14th September, 2024',
        deadline: '21st August, 2024',
        bid_amount_min: 12,
    },
    {
        title: 'Copywriting',
        description: 'You are to write a 500 word article on the importance of technology in the 21st century',
        budget: 100,
        created_at: '14th January, 2024',
        deadline: '21st March, 2024',
        bid_amount_min: 14,
    },
    {
        title: 'Pentesting',
        description: 'You are to test the security of this website and provide a report',
        budget: 100,
        created_at: '14th March, 2024',
        deadline: '21st July, 2024',
        bid_amount_min: 50,
    },
    {
        title: 'Pentesting',
        description: 'You are to test the security of this website and provide a report',
        budget: 100,
        created_at: '14th March, 2024',
        deadline: '21st July, 2024',
        bid_amount_min: 50,
    },
    {
        title: 'Pentesting',
        description: 'You are to test the security of this website and provide a report',
        budget: 100,
        created_at: '14th March, 2024',
        deadline: '21st July, 2024',
        bid_amount_min: 50,
    },
    {
        title: 'Pentesting',
        description: 'You are to test the security of this website and provide a report',
        budget: 100,
        created_at: '14th March, 2024',
        deadline: '21st July, 2024',
        bid_amount_min: 50,
    },
]

const Discovery = () => {
  return (
    <div className='w-full flex flex-col space-y-5'>
        <span className='font-lobster text-3xl'>Discover</span>
        <div className='max-w-screen-lg grid grid-cols-3 gap-4'>
             {
                tasks?.map((task) => (
                    <div className='p-5 border h-[250px] rounded-lg shadow-sm font-jakarta flex flex-col space-y-2'>
                        <span className='font-medium text-md'>{task.description}</span>
                        <div>
                            <span className='text-sm font-semibold'>Budget: </span>
                            <span className='font-bold text-green-500'>{task.budget} ICP</span>
                        </div>
                        <div>
                            <span className='text-sm font-semibold'>Created: </span>
                            <span className='font-medium text-sm'>{task.created_at}</span>
                        </div>
                        <div>
                            <span className='text-sm font-semibold'>Minimum Bid: </span>
                            <span className='font-medium text-sm'>{task.bid_amount_min} ICP</span>
                        </div>
                        <div className='flex justify-between'>
                            <div className='flex flex-col w-full'>
                                <span className='text-sm font-semibold'>Deadline: </span>
                                <span className='font-medium text-sm'>{task.deadline}</span>
                            </div>
                            <Button label={"Bid"} bgStyle={"w-10 h-10"}/>
                        </div>
                    </div>
                ))
             }
        </div>
    </div>
  )
}

export default Discovery
