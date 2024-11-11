import React, { useEffect } from 'react'
import { Tabs } from 'antd'
import BidList from '../components/BidList';

const onChange = (key) => {
    console.log(key);
  };

  const bids = [
    {
      taskId: 34,
      amount: 340,
      created_at: '10th June, 2022',
      status: 'Pending'
    },
    {
      taskId: 64,
      amount: 11,
      created_at: '6th June, 2022',
      status: 'Accepted'
    },
  ]

  const items = [
    {
      key: '1',
      label: 'Pending',
      children:  <BidList bids={bids} status={"Pending"} />
    },
    {
      key: '2',
      label: 'Accepted',
      children: <BidList bids={bids} status={"Accepted"} />,
    },
    {
      key: '3',
      label: 'Rejected',
      children: <BidList bids={bids} status={"Rejected"} />,
    },
  ];

const Bids = () => {
  return (
    <div className='gap-5 flex flex-col'>
      <span className='font-lobster font-semibold text-3xl'>Bids</span>
      <Tabs defaultActiveKey="1" items={items} onChange={onChange} className='w-full'/>
    </div>
  )
}

export default Bids
