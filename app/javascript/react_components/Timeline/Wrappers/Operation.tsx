import * as React from "react";

export default function Operation(props: { type: any, children: any }) {
  let cssClass = '';

  switch (props.type) {
    case 'append': {
      cssClass = 'tw-bg-green-300 tw-p-0.5'
      break;
    }
    case 'remove' : {
      // cssClass = 'tw-opacity-10 hover:tw-opacity-100 tw-relative after:tw-absolute after:tw-content-[""] after:tw-inset-0'
      cssClass = "tw-bg-red-300 tw-p-0.5"
      break;
    }
  }

  return (
    <div className={`tw-rounded tw-text-sm tw-inline-flex tw-relative tw-flex-wrap ${cssClass} `}>
      {props.children}
      {/*<div className="tw-absolute tw-inset-0 tw-backdrop-blur tw-blur tw-bg-white/80 hover:tw-bg-white/0 tw-z-50"></div>*/}
    </div>
  )
}