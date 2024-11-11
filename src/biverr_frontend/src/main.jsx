import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './index.scss';
import {
  createBrowserRouter,
  RouterProvider
} from 'react-router-dom';
import Header from './components/Header';
import SetupProfile from './pages/SetupProfile';
import Discovery from './pages/Discovery';
import DashboardLayout from './Layout/DashboardLayout';
import WelcomeLayout from './Layout/WelcomeLayout';
import TaskDetail from './pages/TaskDetail';
import Bids from './pages/Bids';
import Tasks from './pages/Tasks';

const router = createBrowserRouter([
  {
    path: '/',
    element: <WelcomeLayout />,
    children: [
      {
        path: '',
        element: <App />
      },
      {
        path: 'setup-profile',
        element: <SetupProfile />
      }
    ]
  },
  {
    path: '/setup-profile',
    element: <SetupProfile />
  },
  {
    path: '/dashboard',
    element: <DashboardLayout />,
    children: [
      {
        path: '',
        element: <Discovery />
      },
      {
        path: 'task-detail',
        element: <TaskDetail />
      },
      {
        path: 'bids',
        element: <Bids />
      },
      {
        path: 'tasks',
        element: <Tasks />
      }
    ]
  }
])

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>,
);
