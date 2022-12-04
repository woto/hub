import * as React from 'react';
import {
  Dispatch, SetStateAction, useState, useEffect, useLayoutEffect,
} from 'react';
import { motion } from 'framer-motion';
import { CarouselType, DOMRectJSON } from '../system/TypeScript';
import CarouselItem from './CarouselItem';

function CarouselItems(props: {
  items: any[],
  type: CarouselType,
  selectedItem: any,
  container: any,
  handleMouseClick: (e: React.MouseEvent, item: any) => void
}) {
  return (
    <>
      {props.items.map((item: any, index: number) => (
        // TODO: temporary hack used because 'single' carousel also used same component
        // was item?.id
        <CarouselItem
          key={`index-${index}`}
          selectedItem={props.selectedItem === item ? props.selectedItem : null}
          handleMouseClick={props.handleMouseClick}
          item={item}
          type={props.type}
        />
      ))}
    </>
  );
}

// function areEqual(prevProps, nextProps) {
//   console.log('prevProps.items === nextProps.items', prevProps.items === nextProps.items);
//   console.log('prevProps.type === nextProps.type', prevProps.type === nextProps.type);
//   // console.log('prevProps.carouselId === nextProps.carouselId', prevProps.carouselId === nextProps.carouselId);
//   // console.log('prevProps.setSelectedItemId === nextProps.setSelectedItemId', prevProps.setSelectedItemId === nextProps.setSelectedItemId);
//   return false;
// }

export default React.memo(CarouselItems);
