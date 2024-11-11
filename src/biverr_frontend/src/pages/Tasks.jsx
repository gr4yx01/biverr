import React from 'react';
import { Card, Col, Row } from 'antd';
import { useNavigate } from 'react-router-dom';

const tasks = [
    {
        title: 'Web dev',
        budget: 100,
        status: 'Submitted',
        deadline: '20 September, 2024'
    },
    {
        title: 'Mobile Dev',
        budget: 100,
        status: 'Assigned',
        deadline: '20 September, 2024'
    },
    {
        title: 'Mobile Dev',
        budget: 100,
        status: 'Assigned',
        deadline: '20 September, 2024'
    },
]

const Tasks = () => {
const navigate = useNavigate();

return (
  <div className='space-y-5'>
    <span className='font-lobster font-semibold text-3xl'>Tasks</span>
    <Row gutter={16}>
        {
            tasks?.map((task) => (
                <Col onClick={() => navigate('/dashboard/task-detail')}>
                <Card title={task.title} bordered={false} className=''>
                    <div className='flex flex-col'>
                        <div className='space-x-4 font-jakarta'>
                            <span>Budget:</span>
                            <span className='font-semibold'>{task.budget} ICP</span>
                        </div>
                        <div className='space-x-4 font-jakarta'>
                            <span>Deadline:</span>
                            <span className='font-semibold text-sm'>{task.deadline}</span>
                        </div>
                        <div className='space-x-4 font-jakarta'>
                            <span>Status:</span>
                            <span className='font-semibold'>{task.status}</span>
                        </div>

                    </div>
                </Card>
                </Col>
            ))
        }
    </Row>
  </div>
)
};
export default Tasks;