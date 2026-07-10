export interface Milestone {
  date: string;
  datetime: string;
  title: string;
  desc: string;
  url: string;
}

export const officialHub = 'https://www.contribution.ac/2026ossca';
export const officialNotice = 'https://www.oss.kr/pages/10/4511';
export const program = '2026 오픈소스 컨트리뷰션 아카데미 참여형 일정';

export const milestones: Milestone[] = [
  {
    date: '5월 12일 ~ 6월 14일',
    datetime: '2026-05-12',
    title: '멘티 모집',
    desc: '참여형 프로그램 참가 신청을 받습니다.',
    url: officialNotice,
  },
  {
    date: '6월 15일 ~ 17일',
    datetime: '2026-06-15',
    title: '지원서 취합',
    desc: '접수된 지원서를 프로젝트별로 취합합니다.',
    url: officialNotice,
  },
  {
    date: '6월 18일 ~ 24일',
    datetime: '2026-06-18',
    title: '멘티 선발',
    desc: '프로젝트 팀별 참여 멘티를 선발합니다.',
    url: officialNotice,
  },
  {
    date: '6월 29일',
    datetime: '2026-06-29',
    title: '선정 결과 발표',
    desc: '멘티 선정 결과를 발표합니다.',
    url: officialNotice,
  },
  {
    date: '7월 11일',
    datetime: '2026-07-11',
    title: '발대식',
    desc: '전체 및 팀별 발대식을 진행합니다.',
    url: officialNotice,
  },
  {
    date: '7월 11일 ~ 8월 4일',
    datetime: '2026-07-11',
    title: '챌린저스',
    desc: '프로젝트 적응과 기여 이슈 선정을 진행합니다.',
    url: officialNotice,
  },
  {
    date: '8월 3일 ~ 9일',
    datetime: '2026-08-03',
    title: '중간보고서 작성',
    desc: '멘티 중간보고서를 작성합니다.',
    url: officialNotice,
  },
  {
    date: '8월 15일 ~ 10월 24일',
    datetime: '2026-08-15',
    title: '마스터스',
    desc: '멘토와 함께 집중 기여를 진행합니다.',
    url: officialNotice,
  },
  {
    date: '9월 28일 ~ 10월 5일',
    datetime: '2026-09-28',
    title: '최종보고서 작성',
    desc: '멘티 최종보고서를 작성합니다.',
    url: officialNotice,
  },
  {
    date: '10월 13일 ~ 20일',
    datetime: '2026-10-13',
    title: '서면 평가',
    desc: '최종 평가를 위한 서면 심사를 진행합니다.',
    url: officialNotice,
  },
  {
    date: '10월 24일',
    datetime: '2026-10-24',
    title: '성과공유회',
    desc: '팀별 결과를 발표하고 최종 평가를 진행합니다.',
    url: officialNotice,
  },
  {
    date: '12월 초',
    datetime: '2026-12',
    title: '시상식',
    desc: '우수 참여 팀을 시상합니다.',
    url: officialNotice,
  },
];
