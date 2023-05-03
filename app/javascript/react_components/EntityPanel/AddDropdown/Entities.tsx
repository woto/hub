import { motion } from 'framer-motion';
import * as React from 'react';
import Entity from './Entity';

export default function Entities(props: { data: any[], entities: any[], dispatchEntities: any, close: any }) {
  const {
    data, entities, dispatchEntities, close,
  } = props;

  if (!data || data.length === 0) return null;

  return (
    <>
      { data.map((item: any) => (
        <Entity
          selected={(entities.map((entity) => entity.entity_id).includes(item.entity_id))}
          key={item.entity_id}
          entity={item}
          dispatchEntities={dispatchEntities}
          close={close}
        />
      ))}
    </>
  );
}
