import React, { useEffect, useState } from 'react'
import { Outlet, useNavigate } from 'react-router-dom'
import Sidebar from '../components/Sidebar'
import { user_canister } from 'declarations/user_canister'

const DashboardLayout = () => {
    const [profile, setProfile] = useState({});
    const navigate = useNavigate();

    useEffect(() => {
        const fetchProfile = async () => {
            const profile = await user_canister.getProfile();
            
            setProfile(profile);
        }
        fetchProfile();

      }, []) 
      
      useEffect(() => {
        if(profile?.err == 'Profile not found'){
          navigate("/setup-profile")
        }
      }, [profile])

  return (
    <div className='flex'>
        <Sidebar/>
        <div className='p-10'>
          <Outlet />
        </div>
    </div>
  )
}

export default DashboardLayout
