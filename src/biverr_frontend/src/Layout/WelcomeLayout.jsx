import React from 'react'
import { Outlet } from 'react-router-dom'
import Header from '../components/Header'

const WelcomeLayout = () => {
  return (
    <div>
        <Header />
          <Outlet />
    </div>
  )
}

export default WelcomeLayout
