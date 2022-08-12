import * as React from 'react';
import {CubeIcon} from "@heroicons/react/outline";
import {motion} from 'framer-motion/dist/framer-motion';
import {useState} from "react";

function classNames(...classes) {
  return classes.filter(Boolean).join(' ')
}

// tw-bg-indigo-500' : 'tw-bg-transparent'

// const underline = {
//   initial: {
//     backgroundColor: ['hsl(0, 100, 50) 0%', 'hsl(240, 100, 50) 0%'],
//     transition: {
//       duration: 2,
//       type: "tween",
//       ease: "easeIn"
//     }
//   },
//   hover: {
//     backgroundColor: ['hsl(0, 100, 50)', 'hsl(-120, 100, 50)'],
//     transition: {
//       duration: 2,
//       type: "tween",
//       ease: "easeOut"
//     }
// }}
//
// const button = {
//   initial: {
//     color: ['hsl(0, 100, 50) 0%', 'hsl(240, 100, 50) 0%']
//   },
//   hover: {
//     color: ['hsl(0, 100, 50)', 'hsl(-120, 100, 50)']
//   }
// }

// tab.current ? 'tw-text-gray-900' : 'tw-text-gray-500 hover:tw-text-gray-700',

// <%= render (
//   ReactComponent.new(name: 'EntitiesReport',
//   class: '',
//   props: {
//   entityId: @entity.id,
// })
// ) %>


const tabs = [
  {name: 'Запомнить'},
  {name: 'История'},
  {name: 'Редактировать'},
  {name: 'Репорт'},
]


export default function Buttons(props: { entityId: number }) {

  const [selectedTabIdx, setSelectedTabIdx] = useState()

  function handleMouseEnter(tabIdx) {
    setSelectedTabIdx(tabIdx);
  }

  function handleMouseLeave(tabIdx) {
    setSelectedTabIdx(null);
  }

  return (
    <div className=''>
      <div className="tw-hidden sm:tw-block">
        <nav
          className="tw-border tw-relative tw-z-0 tw-rounded-lg tw-shadow? tw-flex tw-divide-x tw-divide-gray-200 tw-overflow-hidden tw-bg-neutral-100">

          {tabs.map((tab, tabIdx) => (
            <motion.a
              layout
              onMouseEnter={() => {
                handleMouseEnter(tabIdx)
              }}
              onMouseLeave={() => {
                handleMouseLeave(tabIdx)
              }}
              // variants={button}
              key={tab.name}
              // initial={'initial'}
              // animate={'hover'}
              animate={tabIdx === selectedTabIdx ? 'hover' : 'initial'}
              className={classNames(
                tabIdx === 0 ? 'tw-rounded-bl-lg' : '',
                tabIdx === tabs.length - 1 ? 'tw-rounded-br-lg' : '',
                'tw-cursor-pointer tw-text-gray-500 hover:tw-text-gray-700 tw-group tw-relative tw-min-w-0 tw-flex-1 tw-py-3 tw-px-4 tw-text-sm tw-font-medium hover:tw-bg-gray-50 focus:tw-z-10'
              )}
            >

              <span className={'tw-flex tw-items-center tw-justify-center'}>
                <CubeIcon className={"tw-w-6 tw-h-6 tw-mr-2 tw-flex-none"}></CubeIcon>
                {tab.name}
              </span>

              {tabIdx === selectedTabIdx ?
                <motion.span
                  // animate={tabIdx === selectedTabIdx ? 'hover' : 'initial'}
                  layoutId="underline"
                  // variants={underline}
                  className={'tw-bg-indigo-500 tw-absolute tw-inset-x-0 tw-bottom-0 tw-h-0.5 tw-z-10'}
                /> : null}

            </motion.a>
          ))}
        </nav>
      </div>
    </div>
  )
}
