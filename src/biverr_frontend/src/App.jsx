import { useEffect, useRef, useState } from 'react';
import { useGSAP } from "@gsap/react";
import gsap from 'gsap';
import Client from './image/Client'
import Worker from './image/Worker'
import Tasks from './image/Tasks';
// import { user_canister } from 'declarations/user_canister'

gsap.registerPlugin(useGSAP);

function App() {
  const container = useRef();

  // useEffect(() => {
  //   const fetchProfile = async () => {
  //     const profile = await user_canister.getProfile();
  //     console.log(profile)
  //   }

  //   fetchProfile();
  // }, [])

  useGSAP(
    () => {
        gsap.to('.box', { rotation: -20, duration: 0.9 }); // <-- automatically reverted
        gsap.fromTo('.second', { y: -70, opacity: 0 }, { y: 0, opacity: 1, duration: 2, ease: "bounce.out" });
        gsap.from('.third', { y: 100, opacity: 0, duration: 1, ease: "power2.inOut" });
        gsap.to('.fourth', { scale: 1.05, duration: 0.8, repeat: 2, yoyo: true, ease: "power1.inOut" });
    },
    { scope: container }
  );

  return (
    <main ref={container} className='flex h-screen w-full justify-center'>
      <div className='max-w-screen-xl flex flex-col items-center'>
        <div className='flex flex-col p-10 items-center gap-5'>
          <div className='third'>
            <Client width={400} height={400} />
          </div>
          <div className='flex flex-col justify-center items-center gap-3'>
            <span className='text-3xl font-lobster'>A Decentralized Freelance Marketplace.</span>
            <span className='text-center font-jakarta  w-[60vw]'>Discover a decentralized freelance marketplace where clients and freelancers connect with confidence. </span>
          </div>
        </div>
        <div className='flex p-10 items-center gap-5 space-x-10'>
          <div className='second'>
            <Worker width={300} height={400} className="second" />
          </div>
          <div className='w-80 flex-col flex gap-3'>
            <span className='text-3xl font-lobster'>Hire Smarter, Work Freer</span>
            <span className='font-jakarta font-normal'>Tasks are backed by secure escrow and blockchain-powered payments, ensuring fairness and transparency every step of the way</span>
          </div>
        </div>
        <div className='flex p-10 items-center gap-5 space-x-10'>
          <div className='w-80 flex flex-col gap-3'>
            <span className='text-3xl font-lobster'>Freelance Fearlessly – Secure, Decentralized, and Fair</span>
            <span className='font-jakarta'>Say goodbye to hidden fees and unreliable clients!.</span>
          </div>
          <div className='fourth'>
            <Tasks width={300} height={400} />
          </div>
        </div>
      </div>
    </main>
  );
}

export default App;
