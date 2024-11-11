import { useEffect, useState } from 'react'
import { AuthClient } from '@dfinity/auth-client';
import { HttpAgent } from '@dfinity/agent';
import { Modal } from "antd";
import TextInput from './TextInput';
import TextArea from 'antd/es/input/TextArea';
import { DatePicker } from "antd";
import { useNavigate } from 'react-router-dom';

let authClient;
let identity;
let agent;

async function initializeAuthClient() {
    authClient = await AuthClient.create();
    identity = authClient.getIdentity();
    agent = new HttpAgent({ identity });
}

initializeAuthClient();

const Header = () => {
    const [loggedIn, setLoggedIn] = useState(false);
    const [isModalOpen, setIsModalOpen] = useState(false);
    const navigate = useNavigate();

    const showModal = () => {
        setIsModalOpen(true);
      };
  
      const handleOk = () => {
        setIsModalOpen(false);
      };
    const handleCancel = () => {
      setIsModalOpen(false);
    };

    useEffect(() => {
        const checkLoggedIn = async () => {
          authClient = await AuthClient.create();
          const loggedIn = await authClient.isAuthenticated();
          setLoggedIn(loggedIn);
    
          if (loggedIn) {
            identity = authClient.getIdentity();
            agent = new HttpAgent({ identity });

            console.log(identity);
          }
        };
    
        checkLoggedIn();
      }, []);

      console.log(loggedIn)

      const handleLogin = async (e) => {
        e.preventDefault();
    
        authClient = await AuthClient.create();
    
        await new Promise((resolve) => {
          authClient.login({
            identityProvider: process.env.DFX_NETWORK === "ic" 
              ? "https://identity.ic0.app/#authorize"
              : `http://${process.env.CANISTER_ID_INTERNET_IDENTITY}.localhost:4943`,
            onSuccess: resolve
          });
        });
    
        // Re-initialize agent and actor after login
        identity = authClient.getIdentity();
        agent = new HttpAgent({ identity });
        setLoggedIn(true);
      };

      const handleLogout = async (e) => {
        e.preventDefault();
        if (authClient) {
          await authClient.logout();
          setLoggedIn(false);
        }
      };

  return (
    <div className='p-5 border-b font-roboto flex justify-between items-center sticky top-0 bg-white z-30'>
        <div className='flex gap-2'>
            <div className='bg-green-500 w-8 h-8 rounded-l-full flex'/>
                <span className='text-2xl tracking-wider font-medium text-green-500'>BIVERR</span>
                <div className='bg-green-500 w-8 h-8 rounded-r-full'/>
        </div>
        <div className='flex'>
            {
                loggedIn && (
                    <>
                        <div className='gap-3 flex'>
                            <button onClick={() => navigate('/dashboard')} className='text-sm font-medium bg-green-500 text-white border p-3 px-7 rounded-lg'>
                                Dashboard
                            </button>
                            <button onClick={showModal} className='text-sm font-medium bg-green-500 text-white border p-3 px-7 rounded-lg'>
                                Deposit
                            </button>
                            <button onClick={handleLogout} className='text-sm font-medium text-green-500 border p-3 px-7 rounded-lg'>
                                Logout
                            </button>
                        </div>
                    </>
                )
            }
{
                !loggedIn && (
                    <button onClick={handleLogin} className='text-sm font-medium text-green-500 rounded-lg border p-3'>
                        Sign in with Internet identity
                    </button>
                )
            }
        </div>

      <Modal title="Fund your Account" open={isModalOpen} onOk={handleOk} onCancel={handleCancel}>
        <TextInput label={"Enter amount?"}/>
      </Modal>
    </div>
  )
}

export default Header
