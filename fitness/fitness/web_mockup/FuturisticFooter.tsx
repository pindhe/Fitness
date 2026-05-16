import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Home, Users, CreditCard, BarChart2 } from 'lucide-react';

const FuturisticFooter = () => {
  const [activeTab, setActiveTab] = useState('payments');

  const tabs = [
    { id: 'home', label: 'Home', icon: Home },
    { id: 'members', label: 'Members', icon: Users },
    { id: 'payments', label: 'Payments', icon: CreditCard },
    { id: 'analytics', label: 'Analytics', icon: BarChart2 },
  ];

  return (
    <div className="fixed bottom-0 left-0 right-0 p-6 flex justify-center items-end pointer-events-none">
      <motion.nav 
        initial={{ y: 100, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ type: 'spring', damping: 20, stiffness: 100 }}
        className="relative w-full max-w-md h-20 bg-[#050816]/80 backdrop-blur-2xl rounded-[32px] border border-white/5 shadow-[0_-10px_40px_rgba(0,0,0,0.4)] pointer-events-auto overflow-hidden flex items-center justify-around px-4"
      >
        {/* Animated Neon Border Glow */}
        <div className="absolute inset-0 rounded-[32px] border border-emerald-400/20 pointer-events-none" />
        
        {tabs.map((tab) => {
          const Icon = tab.icon;
          const isActive = activeTab === tab.id;

          return (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className="relative flex flex-col items-center justify-center w-16 h-full transition-all duration-300 group"
            >
              <AnimatePresence>
                {isActive && (
                  <motion.div
                    layoutId="activeGlow"
                    className="absolute -top-4 w-12 h-12 bg-emerald-400/10 blur-xl rounded-full"
                    transition={{ type: 'spring', bounce: 0.2, duration: 0.6 }}
                  />
                )}
              </AnimatePresence>

              <div className="relative">
                <motion.div
                  animate={{
                    scale: isActive ? 1.2 : 1,
                    y: isActive ? -4 : 0,
                    color: isActive ? '#00FF9D' : '#6B7280'
                  }}
                  className="relative z-10"
                >
                  <Icon size={22} strokeWidth={isActive ? 2.5 : 2} />
                </motion.div>

                {isActive && (
                  <motion.div
                    layoutId="activeIndicator"
                    className="absolute -bottom-8 left-1/2 -translate-x-1/2 w-1.5 h-1.5 bg-emerald-400 rounded-full shadow-[0_0_10px_#00FF9D]"
                  />
                )}
              </div>

              <motion.span
                animate={{
                  opacity: isActive ? 1 : 0.6,
                  scale: isActive ? 1.1 : 1,
                  color: isActive ? '#FFFFFF' : '#6B7280'
                }}
                className="text-[10px] font-bold mt-1.5 tracking-wider uppercase"
              >
                {tab.label}
              </motion.span>

              {/* Interaction Ripple Effect Mock */}
              <div className="absolute inset-0 bg-emerald-400/0 group-active:bg-emerald-400/5 transition-colors rounded-2xl" />
            </button>
          );
        })}
      </motion.nav>
    </div>
  );
};

export default FuturisticFooter;
