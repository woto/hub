/* This example requires Tailwind CSS v2.0+ */
import {Fragment, useState} from 'react'
import * as React from 'react';
import {Popover, Transition} from '@headlessui/react'
import {ChevronDownIcon} from '@heroicons/react/24/outline';
import Relevance from "./Relevance";
import Sentiment from "./Sentiment";


function classNames(...classes) {
  return classes.filter(Boolean).join(' ')
}

export default function EditCircle(props: { imageSrc: string }) {
  let [referenceElement, setReferenceElement] = useState()
  let [popperElement, setPopperElement] = useState()
  // let { styles, attributes } = usePopper(referenceElement, popperElement, {
  //   // strategy: 'fixed',
  //   placement: "bottom-start",
  //   modifiers: [
  //     {
  //       name: "offset",
  //       options: {
  //         offset: [-24, 13]
  //       }
  //     },
  //     {
  //       name: 'flip',
  //       options: {
  //         flipVariations: false, // true by default
  //         allowedAutoPlacements: ['bottom-start'], // by default, all the placements are allowed
  //       },
  //     },
  //     // {
  //     //   name: 'preventOverflow',
  //     //   options: {
  //     //     mainAxis: true, // true by default
  //     //     altAxis: true, // false by default
  //     //   },
  //     // },
  //     // {
  //     //   name: 'flip'
  //     // }
  //   ]
  // })

  return (

    // <div className="tw-p-1 tw-flex tw-items-center tw-space-x-2.5 tw-relative tw-z-0 tw-overflow-hidden">
    //
    // </div>

    <Popover ref={setReferenceElement} className="tw-relative?">
      {({open}) => (
        <>
          <Popover.Button
            className={"tw-rounded-full focus:tw-ring-indigo-300 focus:tw-ring tw-outline-none"}
          >
            <img
              className="tw-relative tw-inline-block tw-h-10 tw-w-10
              tw-rounded-full tw-object-scale-down
              tw-bg-white tw-border-2 tw-border-white tw-shadow"
              src={props.imageSrc}
            />
          </Popover.Button>

          {/*<div*/}
          {/*  className={"tw-w-screen tw-max-w-sm"}*/}
          {/*  ref={setPopperElement}*/}
          {/*  style={styles.popper}*/}
          {/*  {...attributes.popper}*/}
          {/*>*/}

          <Transition
            as={Fragment}
            enter="tw-transition tw-ease-out tw-duration-300"
            enterFrom="tw-opacity-0 tw-translate-y-1"
            enterTo="tw-opacity-100 tw-translate-y-0"
            leave="tw-transition tw-ease-in tw-duration-150"
            leaveFrom="tw-opacity-100 tw-translate-y-0"
            leaveTo="tw-opacity-0 tw-translate-y-1"
          >
            <Popover.Panel
              className={`tw-absolute tw-z-10 tw-left-0 tw-mt-[13px]
               tw-ring-1 tw-ring-gray-200
              tw-grid tw-gap-4 tw-bg-slate-50 tw-px-5 tw-py-6`}
            >
                  <Relevance></Relevance>
                  <Sentiment></Sentiment>
                  <div className={"tw-text-left"}>
                    <button
                      type="button"
                      className="tw-mt-2 tw-inline-flex tw-items-center tw-px-3 tw-py-2 tw-border tw-border-transparent
                    tw-text-sm tw-leading-4 tw-tw-font-medium tw-rounded-md  tw-text-white tw-bg-indigo-600
                    hover:tw-bg-indigo-700 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2
                    focus:tw-ring-indigo-500"
                    >
                      Применить
                    </button>
                  </div>
                  {/*{solutions.map((item) => (*/}
                  {/*  <a*/}
                  {/*    key={item.name}*/}
                  {/*    href={item.href}*/}
                  {/*    className="-tw-m-3 tw-p-3 tw-block tw-rounded-md hover:tw-bg-gray-50 tw-transition tw-ease-in-out tw-duration-150"*/}
                  {/*  >*/}
                  {/*    <p className="tw-text-base tw-font-medium tw-text-gray-900">{item.name}</p>*/}
                  {/*    <p className="tw-mt-1 tw-text-sm tw-text-gray-500">{item.description}</p>*/}
                  {/*  </a>*/}
                  {/*))}*/}
            </Popover.Panel>
          </Transition>
          {/*</div>*/}
        </>
      )}
    </Popover>
  )
}
