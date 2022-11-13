import { motion } from 'framer-motion';
import * as React from 'react';
import Entity from './Entity';

export default function Entities(props: { entities: any }) {
  return (
   props.entities && props.entities.map((entity: any, idx: number) => <Entity key={idx} entity={entity} />)
  );
}
