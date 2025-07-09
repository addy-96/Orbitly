const notesTable = 'notes';
const sectionTable = 'sections';

//notes table columns -ntc
const notesIdNTC = 'notesId';
const notesTitleNTC = 'notesTitle';
const createdAtNTC = 'createdAt';
const modifiedAtNTC = 'modifiedAt';
const notesContentHighLightNTC = 'notesContentHighLight';

//seectiosn table columns -stc
const sectioonIdSTC = 'sectionId';
const notesIdSTC = 'notesId';
const sectionNoSTC = 'sectionNo';
const typeSTC = 'type';
const contentSTC = 'content';


const Map<int, String> months = {
  0: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'Septemeber',
  10: 'October',
  11: 'November',
  12: 'December',
};

DateTime getDateTime() {
  return DateTime.now();
}
