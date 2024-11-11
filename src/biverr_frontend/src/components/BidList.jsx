import React, { useEffect, useState } from 'react'
import { Link, useNavigate } from 'react-router-dom';

const BidList = ({ bids, status }) => {
    const [bidsToDisplay, setBidsToDisplay] = useState([])
    const navigate = useNavigate();

    useEffect(() => {
        const filter = bids.filter((bid) => bid.status == status);
        setBidsToDisplay(filter);
    }, [status])

  return (
    <div>
      {
        bidsToDisplay?.map((bid) => (
            <button onClick={() => navigate("/dashboard/task-detail")} className='border p-3 w-full rounded-lg'>
                <div className='flex justify-between'>
                    <span className='font-semibold font-jakarta'>Task id: </span>
                    <span>{bid.taskId}</span>
                </div>
                <div className='flex justify-between'>
                    <span className='font-semibold font-jakarta'>Created:</span>
                    <span>{bid.created_at}</span>
                </div>
                <div className='flex justify-between'>
                    <span className='font-semibold font-jakarta'>Bid:</span>
                    <span>{bid.amount}</span>
                </div>
            </button>
        ))
      }
    </div>
  )
}

export default BidList
