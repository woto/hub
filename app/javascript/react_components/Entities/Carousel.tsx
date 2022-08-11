import * as React from "react";
import {ScrollingCarousel} from '@trendyol-js/react-carousel';
import {ArrowLeftIcon, ArrowRightIcon} from "@heroicons/react/solid";
type Image = {
  height: string,
  id: number,
  original: string
  width: number,
  dark: boolean,
  images: {
    '50': string,
    '100': string,
    '200': string,
    '300': string,
    '500': string,
    '1000': string
  }
  videos: {
    '50': string,
    '100': string,
    '200': string,
    '300': string,
    '500': string,
    '1000': string
  }
}

function Text(props: { text: string }) {
  return (
    <div className="tw-min-w-[300px] tw-min-h-[300px] tw-flex tw-h-full tw-rounded-md tw-max-w-[400px] tw-leading-7">
      {props.text}
    </div>
  )
}

function Image(props: { image: Image }) {
  return (
    <div className={`tw-min-w-[300px] tw-min-h-[300px] tw-flex tw-justify-center tw-items-center tw-p-2 sm:tw-p-3 tw-rounded-md
                   ${props.image.dark ? 'tw-bg-slate-800' : 'tw-bg-white'}
    `}>
      <img src={props.image.images['500']}
           className="tw-h-full tw-max-h-[300px] tw-rounded tw-object-scale-down"
      />
    </div>
  )
}

export default function EntitiesCarousel(props: { images: Image[], text: string }) {

  let content = [
    ...props.images.slice(0, 1).map((image) => <Image image={image}></Image>),
    <Text text={props.text}></Text>,
    ...props.images.slice(1).map((image) => <Image image={image}></Image>),
  ]

  const margin = (index: number, length: number) => {
    if (index === 0) return 'tw-mr-2 sm:tw-mr-3';
    if (index === length - 1) return 'tw-ml-2 sm:tw-ml-3';
    return 'tw-mx-2 sm:tw-mx-3';
  }

  return (
    <div className="tw-bg-gray-100 sm:tw-p-3 sm:tw-rounded-t-lg tw-relative">
      <ScrollingCarousel
        leftIcon={
          <button
            type="button"
            className="tw-absolute -tw-left-3 sm:-tw-left-7 tw-top-1/2 -tw-translate-y-1/2 tw-inline-flex tw-items-center tw-p-2 tw-border tw-border-transparent tw-rounded-full tw-shadow-sm tw-text-indigo-400 tw-bg-indigo-100 hover:tw-bg-indigo-200 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-500"
          >
            <ArrowLeftIcon className="tw-h-5 tw-w-5" aria-hidden="true"/>
          </button>
        }
        rightIcon={
          <button
            type="button"
            className="tw-absolute -tw-right-3 sm:-tw-right-7 tw-top-1/2 -tw-translate-y-1/2 tw-inline-flex tw-items-center tw-p-2 tw-border tw-border-transparent tw-rounded-full tw-shadow-sm tw-text-indigo-400 tw-bg-indigo-100 hover:tw-bg-indigo-200 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-500"
          >
            <ArrowRightIcon className="tw-h-5 tw-w-5" aria-hidden="true"/>
          </button>
        }
      >
        {content.map((Content: any, index) =>
          <div
            key={index}
            className={`
                 ${margin(index, content.length)}
                 ${index === 1 || content.length === 1 ? 'tw-text-gray-500' : 'tw-bg-white tw-border tw-border-slate-200'}
                 tw-flex tw-items-center tw-select-none tw-rounded-md`}
          >
            {Content}
          </div>
        )}
      </ScrollingCarousel>
    </div>
  )
}